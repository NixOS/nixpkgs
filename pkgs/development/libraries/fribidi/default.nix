{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, fixDarwinDylibNames
, python3
}:

stdenv.mkDerivation rec {
  pname = "fribidi";
  version = "1.0.10";

  outputs = [ "out" "devdoc" ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "009wcpgk4jj5x52skjkfs6xar6x38mcngs75rb59nj9ig1y6h73z";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkgconfig ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  doCheck = true;
  checkInputs = [ python3 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
