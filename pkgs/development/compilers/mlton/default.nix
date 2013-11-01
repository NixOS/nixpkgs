{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "mlton-20100608";

  binSrc =
    if stdenv.system == "i686-linux" then (fetchurl {
      url = "http://sourceforge.net/projects/mlton/files/mlton/20100608/${name}-1.x86-linux.static.tgz";
      sha256 = "16qg8df9hg2pmnsblkgxp6bgm7334rsqkxqzskv5fl21wivmnwfw";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl {
        url = "http://sourceforge.net/projects/mlton/files/mlton/20100608/${name}-1.amd64-linux.static.tgz";
        sha256 = "0i6ic8f6prl0cigrmf6bj9kqz3plzappxn17lz1rg2v832nfbw9r";
    })
    else throw "Architecture not supported";

  codeSrc =
    fetchurl {
      url = "http://sourceforge.net/projects/mlton/files/mlton/20100608/${name}.src.tgz";
      sha256 = "0cqb3k6ld9965hyyfyayi510f205vqzd5qqm3crh13nasvq2rjzj";
    };

  srcs = [ binSrc codeSrc ];

  sourceRoot = name;

  buildInputs = [ gmp ];

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
