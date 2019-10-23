{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, fixDarwinDylibNames
, python3
}:

stdenv.mkDerivation rec {
  pname = "fribidi";
  version = "1.0.7";

  outputs = [ "out" "devdoc" ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "0pckda4fcn0aw32lpycwdp25r2m7vca8zspq815ppi9gkwgg5das";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkgconfig ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  doCheck = true;
  checkInputs = [ python3 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/fribidi/fribidi;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
