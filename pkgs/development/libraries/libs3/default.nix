{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  curl,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "libs3";
  version = "unstable-2019-04-10";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "287e4bee6fd430ffb52604049de80a27a77ff6b4";
    hash = "sha256-xgiY8oJlRMiXB1fw5dhNidfaq18YVwaJ8aErKU11O6U=";
  };

  patches = [
    (fetchpatch {
      # Fix compilation with openssl 3.0
      url = "https://github.com/bji/libs3/pull/112/commits/3c3a1cf915e62b730db854d8007ba835cb38677c.patch";
      hash = "sha256-+rWRh8dOznHlamc/T9qbgN0E2Rww3Hn94UeErxNDccs=";
    })
  ];

  buildInputs = [
    curl
    libxml2
  ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/bji/libs3";
    description = "A library for interfacing with amazon s3";
    mainProgram = "s3";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
