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
        sha256 = "1kxjjmnw4xk2d9hpvz43w9dvyhb3025k4zvjx785c33nrwkrdn4j";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}-1.amd64-linux.tgz";
        sha256 = "0fyhwxb4nmpirjbjcvk9f6w67gmn2gkz7xcgz0xbfih9kc015ygn";
      })
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      (fetchurl {
        url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}-1.amd64-darwin.gmp-macports.tgz";
        sha256 = "044wnh9hhg6if886xy805683k0as347xd37r0r1yi4x7qlxzzgx9";
      })
    else
      throw "Architecture not supported";

  codeSrc = fetchurl {
    url = "mirror://sourceforge/project/mlton/mlton/${version}/${pname}-${version}.src.tgz";
    sha256 = "0v1x2hrh9hiqkvnbq11kf34v4i5a2x0ffxbzqaa8skyl26nmfn11";
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
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 's|XCFLAGS += -I/usr/local/include -I/sw/include -I/opt/local/include||' ./runtime/Makefile
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

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Patch ELF interpreter.
    patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/lib/mlton/mlton-compile
    for e in mllex mlyacc ; do
      patchelf --set-interpreter ${dynamic_linker} $(pwd)/../${usr_prefix}/bin/$e
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Patch libgmp linking
    install_name_tool -change /opt/local/lib/libgmp.10.dylib ${gmp}/lib/libgmp.10.dylib $(pwd)/../${usr_prefix}/lib/mlton/mlton-compile
    install_name_tool -change /opt/local/lib/libgmp.10.dylib ${gmp}/lib/libgmp.10.dylib $(pwd)/../${usr_prefix}/bin/mlyacc
    install_name_tool -change /opt/local/lib/libgmp.10.dylib ${gmp}/lib/libgmp.10.dylib $(pwd)/../${usr_prefix}/bin/mllex
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
