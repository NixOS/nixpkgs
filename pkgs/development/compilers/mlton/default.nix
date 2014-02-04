{ stdenv, fetchurl, patchelf, gmp }:

let
  version = "20130715";
in
stdenv.mkDerivation rec {
  name = "mlton-${version}";

  binSrc =
    if stdenv.system == "i686-linux" then (fetchurl {
      url = "http://sourceforge.net/projects/mlton/files/mlton/${version}/${name}-1.x86-linux.tgz";
      sha256 = "1kxjjmnw4xk2d9hpvz43w9dvyhb3025k4zvjx785c33nrwkrdn4j";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl {
        url = "http://sourceforge.net/projects/mlton/files/mlton/${version}/${name}-1.amd64-linux.tgz";
        sha256 = "0fyhwxb4nmpirjbjcvk9f6w67gmn2gkz7xcgz0xbfih9kc015ygn";
    })
    else throw "Architecture not supported";

  codeSrc =
    fetchurl {
      url = "http://sourceforge.net/projects/mlton/files/mlton/${version}/${name}.src.tgz";
      sha256 = "0v1x2hrh9hiqkvnbq11kf34v4i5a2x0ffxbzqaa8skyl26nmfn11";
    };

  srcs = [ binSrc codeSrc ];

  sourceRoot = name;

  buildInputs = [ patchelf gmp ];

  makeFlags = [ "all-no-docs" ];

  configurePhase = ''
    # Fix paths in the source.
    find . -type f | grep -v -e '\.tgz''$' | xargs sed -i "s@/usr/bin/env bash@$(type -p bash)@"

    substituteInPlace $(pwd)/Makefile --replace '/bin/cp' $(type -p cp)

    # Fix paths in the binary distribution.
    BIN_DIST_DIR="$(pwd)/../usr"
    for f in "bin/mlton" "lib/mlton/platform" "lib/mlton/static-library" ; do
      substituteInPlace "$BIN_DIST_DIR/$f" --replace '/usr/bin/env bash' $(type -p bash)
    done

    substituteInPlace $(pwd)/../usr/bin/mlton --replace '/usr/lib/mlton' $(pwd)/../usr/lib/mlton
  '';

  preBuild = ''
    # To build the source we have to put the binary distribution in the $PATH.
    export PATH="$PATH:$(pwd)/../usr/bin/"

    # Let the builder execute the binary distribution.
    chmod u+x $(pwd)/../usr/bin/mllex
    chmod u+x $(pwd)/../usr/bin/mlyacc
    chmod u+x $(pwd)/../usr/bin/mlton

    # So the builder runs the binary compiler with gmp.
    export LD_LIBRARY_PATH=${gmp}/lib:$LD_LIBRARY_PATH

    # Patch ELF interpreter.
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $(pwd)/../usr/lib/mlton/mlton-compile
    for e in mllex mlyacc ; do
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $(pwd)/../usr/bin/$e
    done
  '';

  doCheck = true;

  installTargets = [ "install-no-docs" ];

  postInstall = ''
    # Fix path to mlton libraries.
    substituteInPlace $(pwd)/install/usr/bin/mlton --replace '/usr/lib/mlton' $out/lib/mlton

    # Path to libgmp.
    substituteInPlace $(pwd)/install/usr/bin/mlton --replace "-link-opt '-lm -lgmp'" "-link-opt '-lm -lgmp -L${gmp}/lib'"

    # Path to gmp.h.
    substituteInPlace $(pwd)/install/usr/bin/mlton --replace "-cc-opt '-O1 -fno-common'" "-cc-opt '-O1 -fno-common -I${gmp}/include'"

    # Path to the same gcc used in the build; needed at runtime.
    substituteInPlace $(pwd)/install/usr/bin/mlton --replace "gcc='gcc'" "gcc='"$(type -p gcc)"'"

    # Copy files to final positions.
    cp -r $(pwd)/install/usr/bin $out
    cp -r $(pwd)/install/usr/lib $out
    cp -r $(pwd)/install/usr/man $out
  '';

  meta = {
    description = "Open-source, whole-program, optimizing Standard ML compiler";
    longDescription = ''
      MLton is an open source, whole-program optimizing compiler for the Standard ML programming language.
      MLton aims to produce fast executables, and to encourage rapid prototyping and modular programming
      by eliminating performance penalties often associated with the use of high-level language features.
      MLton development began in 1997, and continues to this day with a growing worldwide community of
      developers and users, who have helped to port MLton to a number of platforms.
      Description taken from http://en.wikipedia.org/wiki/Mlton .
    '';

    homepage = http://mlton.org/;
    license = "bsd";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
