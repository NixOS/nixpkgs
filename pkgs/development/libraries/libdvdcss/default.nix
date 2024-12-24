{
  lib,
  stdenv,
  fetchurl,
  IOKit,
}:

stdenv.mkDerivation rec {
  pname = "libdvdcss";
  version = "1.4.3";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin IOKit;

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-IzzJL13AHF06lvWzWCvn1c7lo1pS06CBWHRdPYYHAHk=";
  };

  meta = with lib; {
    homepage = "http://www.videolan.org/developers/libdvdcss.html";
    description = "Library for decrypting DVDs";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };
}
