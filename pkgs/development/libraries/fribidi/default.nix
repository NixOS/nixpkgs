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
  version = "1.0.5";

  outputs = [ "out" "devdoc" ];

  # NOTE: 2018-06-06 v1.0.5: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "1kp4b1hpx2ky20ixgy2xhj5iygfl7ps5k9kglh1z5i7mhykg4r3a";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fribidi/fribidi/pull/88.patch";
      sha256 = "1n4l6333vhbxfckwg101flmvq6bbygg66fjp69ddcjqaqb6gh9k9";
    })
    (fetchpatch {
      name = "CVE-2019-18397.patch";
      url = "https://github.com/fribidi/fribidi/commit/034c6e9a1d296286305f4cfd1e0072b879f52568.patch";
      sha256 = "102xrbf1l5gvavkxd6csx8pj3rlgcw10c0y4h4d40yhn84b1p0y8";
    })
  ];

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
