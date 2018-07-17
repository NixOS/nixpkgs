{ stdenv
, fetchurl

, meson
, ninja
, pkgconfig
, fixDarwinDylibNames
, python3
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fribidi";
  version = "1.0.4";

  outputs = [ "out" "devdoc" ];

  # NOTE: 2018-06-06 v1.0.4: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "1gipy8fjyn6i4qrhima02x8xs493d21f22dijp88nk807razxgcl";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  checkInptus = [ python3 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/fribidi/fribidi;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
