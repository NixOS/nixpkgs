{ lib, stdenv, fetchurl, fetchpatch, fetchzip, perl, ncurses

  # for tests
, aspell, glibc, runCommand

, searchNixProfiles ? true
}:

let

  # Source for u-deva.cmap and u-deva.cset: use the Marathi
  # dictionary like Debian does.
  devaMapsSource = fetchzip {
    name = "aspell-u-deva";
    url = "https://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2";
    sha256 = "1v8cdl8x2j1d4vbvsq1xrqys69bbccd6mi03fywrhkrrljviyri1";
  };

in

stdenv.mkDerivation rec {
  pname = "aspell";
  version = "0.60.8";

  src = fetchurl {
    url = "mirror://gnu/aspell/aspell-${version}.tar.gz";
    sha256 = "1wi60ankalmh8ds7nplz434jd7j94gdvbahdwsr539rlad8pxdzr";
  };

  patches = [
    (fetchpatch {
      #  objstack: assert that the alloc size will fit within a chunk
      name = "CVE-2019-25051.patch";
      url = "https://github.com/gnuaspell/aspell/commit/0718b375425aad8e54e1150313b862e4c6fd324a.patch";
      sha256 = "03z259xrk41x3j190gaprf3mqysyfgh3a04rjmch3h625vj95x39";
    })
  ] ++ lib.optional searchNixProfiles ./data-dirs-from-nix-profiles.patch;

  postPatch = ''
    patch interfaces/cc/aspell.h < ${./clang.patch}
  '';

  nativeBuildInputs = [ perl ];
  buildInputs = [ ncurses perl ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  # Include u-deva.cmap and u-deva.cset in the aspell package
  # to avoid conflict between 'mr' and 'hi' dictionaries as they
  # both include those files.
  postInstall = ''
    cp ${devaMapsSource}/u-deva.{cmap,cset} $out/lib/aspell/
  '';

  passthru.tests = {
    uses-curses = runCommand "${pname}-curses" {
      buildInputs = [ glibc ];
    } ''
      if ! ldd ${aspell}/bin/aspell | grep -q ${ncurses}
      then
        echo "Test failure: It does not look like aspell picked up the curses dependency."
        exit 1
      fi
      touch $out
    '';
  };

  meta = {
    description = "Spell checker for many languages";
    homepage = "http://aspell.net/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; all;
  };
}
