{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  gmp,
}:

let
  version = "20130715";

  usr_prefix = if stdenv.hostPlatform.isDarwin then "usr/local" else "usr";

  dynamic_linker = stdenv.cc.bintools.dynamicLinker;
in

stdenv.mkDerivation rec {
  pname = "mlton";
  inherit version;

  binSrc =
    if stdenv.hostPlatform.system == "i686-linux" then
      (fetchurl {
        url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}-1.x86-linux.tgz";
        hash = "sha256-ktiWJ892DFbQ6XJ/MosAY0G/W+KD/H1hamJ2wm2Vss8=";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}-1.amd64-linux.tgz";
        hash = "sha256-9vkSAJsJRrc6+I/18+cTtr5juHFpbiaXzPFWS1bn0Ds=";
      })
    else
      throw "Architecture not supported";

  codeSrc = fetchurl {
    url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}.src.tgz";
    hash = "sha256-IVhXrRHUT42Uwn9150AXqkSyyXAzBLzsnjjCBDMUPWw=";
  };

  srcs = [
    binSrc
    codeSrc
  ];

  sourceRoot = "${pname}-${version}";

  buildInputs = [ gmp ];
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux patchelf;

  makeFlags = [ "all-no-docs" ];

  configurePhase = ''
    # Fix paths in the source.
    find . -type f | grep -v -e '\.tgz''$' | xargs sed -i "s@/usr/bin/env bash@$(type -p bash)@"

    substituteInPlace $(pwd)/Makefile --replace '/bin/cp' $(type -p cp)
    substituteInPlace bin/mlton-script --replace gcc cc
    substituteInPlace bin/regression --replace gcc cc
    substituteInPlace lib/mlnlffi-lib/Makefile --replace gcc cc
    substituteInPlace mlnlffigen/gen-cppcmd --replace gcc cc
    substituteInPlace runtime/Makefile --replace gcc cc
    substituteInPlace ../${usr_prefix}/bin/mlton --replace gcc cc

    # Fix paths in the binary distribution.
    BIN_DIST_DIR="$(pwd)/../${usr_prefix}"
    for f in "bin/mlton" "lib/mlton/platform" "lib/mlton/static-library" ; do
      substituteInPlace "$BIN_DIST_DIR/$f" --replace '/${usr_prefix}/bin/env bash' $(type -p bash)
    done

    substituteInPlace $(pwd)/../${usr_prefix}/bin/mlton --replace '/${usr_prefix}/lib/mlton' $(pwd)/../${usr_prefix}/lib/mlton
  ''
  + lib.optionalString stdenv.cc.isClang ''
    sed -i "s_	patch -s -p0 <gdtoa.hide-public-fns.patch_	patch -s -p0 <gdtoa.hide-public-fns.patch\n\tsed -i 's|printf(emptyfmt|printf(\"\"|g' ./gdtoa/arithchk.c_" ./runtime/Makefile
  '';

  preBuild = ''
    # To build the source we have to put the binary distribution in the $PATH.
    export PATH="$PATH:$(pwd)/../${usr_prefix}/bin/"

    # Let the builder execute the binary distribution.
    chmod u+x $(pwd)/../${usr_prefix}/bin/mllex
    chmod u+x $(pwd)/../${usr_prefix}/bin/mlyacc
    chmod u+x $(pwd)/../${usr_prefix}/bin/mlton

    # So the builder runs the binary compiler with gmp.
    export LD_LIBRARY_PATH=${gmp.out}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH

    # Patch ELF interpreter.
    patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/lib/mlton/mlton-compile
    for e in mllex mlyacc ; do
      patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/bin/$e
    done
  '';

  doCheck = true;

  installTargets = [ "install-no-docs" ];

  postInstall = ''
    # Fix path to mlton libraries.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace '/${usr_prefix}/lib/mlton' $out/lib/mlton

    # Path to libgmp.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "-link-opt '-lm -lgmp'" "-link-opt '-lm -lgmp -L${gmp.out}/lib'"

    # Path to gmp.h.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "-cc-opt '-O1 -fno-common'" "-cc-opt '-O1 -fno-common -I${gmp.dev}/include'"

    # Path to the same cc used in the build; needed at runtime.
    substituteInPlace $(pwd)/install/${usr_prefix}/bin/mlton --replace "gcc='gcc'" "gcc='"$(type -p cc)"'"

    # Copy files to final positions.
    cp -r $(pwd)/install/${usr_prefix}/bin $out
    cp -r $(pwd)/install/${usr_prefix}/lib $out
    cp -r $(pwd)/install/${usr_prefix}/man $out
  '';

  meta = import ./meta.nix { inherit lib; };
}
