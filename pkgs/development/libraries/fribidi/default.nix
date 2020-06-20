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

  patches = [
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
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
