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
  name = "${pname}-${version}";
  pname = "fribidi";
  version = "1.0.5";

  outputs = [ "out" "devdoc" ];

  # NOTE: 2018-06-06 v1.0.5: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "1kp4b1hpx2ky20ixgy2xhj5iygfl7ps5k9kglh1z5i7mhykg4r3a";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fribidi/fribidi/pull/88.patch";
      sha256 = "1n4l6333vhbxfckwg101flmvq6bbygg66fjp69ddcjqaqb6gh9k9";
    })
  ];

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
