{stdenv, fetchurl, perl
, searchNixProfiles ? true}:

stdenv.mkDerivation rec {
  name = "aspell-0.60.6.1";

  src = fetchurl {
    url = "mirror://gnu/aspell/${name}.tar.gz";
    sha256 = "1qgn5psfyhbrnap275xjfrzppf5a83fb67gpql0kfqv37al869gm";
  };

  patchPhase = ''
    patch interfaces/cc/aspell.h < ${./clang.patch}
  '' + stdenv.lib.optionalString searchNixProfiles ''
    patch -p1 < ${./data-dirs-from-nix-profiles.patch}
  '';

  buildInputs = [ perl ];

  doCheck = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-pkglibdir=$out/lib/aspell
      --enable-pkgdatadir=$out/lib/aspell
    );
  '';

  meta = {
    description = "Spell checker for many languages";
    homepage = http://aspell.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = with stdenv.lib.platforms; all;
  };
}
