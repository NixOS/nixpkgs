{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "clean-2.3";

  src =
    if stdenv.system == "i686-linux" then (fetchurl {
      url = "http://clean.cs.ru.nl/download/Clean23/linux/clean2.3_boot.tar.gz";
      sha256 = "0rrjpqdbqwbx7n8v35wi3wpm6lpv9zd1n5q50byb2h0ljqw31j9h";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl {
        url = "http://clean.cs.ru.nl/download/Clean23/linux/clean2.3_64_boot.tar.gz";
        sha256 = "0bvkaiwcaa1p6h1bl4bgnia1yd0j8nq6sb1yiwar74y2m1wwmjqj";
    })
    else throw "Architecture not supported";

  # clm uses timestamps of dcl, icl, abc and o files to decide what must be rebuild
  # and for chroot builds all of the library files will have equal timestamps.  This
  # makes clm try to rebuild the library modules (and fail due to absence of write permission
  # on the Nix store) every time any file is compiled.
  patches = [ ./chroot-build-support-do-not-rebuild-equal-timestamps.patch ];

  preBuild = ''
    substituteInPlace Makefile --replace 'INSTALL_DIR = $(CURRENTDIR)' 'INSTALL_DIR = '$out

    substituteInPlace src/tools/clm/clm.c --replace '/usr/bin/gcc' $(type -p gcc)
    substituteInPlace src/tools/clm/clm.c --replace '/usr/bin/as' $(type -p as)

    cd src
  '';

  postBuild = ''
    cd ..
  '';

  meta = {
    description = "Clean is a general purpose, state-of-the-art, pure and lazy functional programming language.";
    longDescription = ''
      Clean is a general purpose, state-of-the-art, pure and lazy functional
      programming language designed for making real-world applications. Some
      of its most notable language features are uniqueness typing, dynamic typing,
      and generic functions.
    '';

    homepage = http://wiki.clean.cs.ru.nl/Clean;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
