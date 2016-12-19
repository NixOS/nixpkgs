{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "clean-2.4";

  src =
    if stdenv.system == "i686-linux" then (fetchurl {
      url = "http://clean.cs.ru.nl/download/Clean24/linux/clean2.4_boot.tar.gz";
      sha256 = "1w8vvmkwzq8g51639r62apcy75sj69nm08082a34xvqm9ymfgkq5";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl {
        url = "http://clean.cs.ru.nl/download/Clean24/linux/clean2.4_64_boot.tar.gz";
        sha256 = "08gsa1pjl5wyzh4ah8ccfx8a7mdcn6ycsn1lzkrr9adygv1gmm7r";
    })
    else throw "Architecture not supported";

  hardeningDisable = [ "format" "pic" ];

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
    description = "General purpose, state-of-the-art, pure and lazy functional programming language";
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
