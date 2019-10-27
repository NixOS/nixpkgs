{ stdenv, fetchurl, pkgconfig, pcsclite, libzip, help2man }:

stdenv.mkDerivation rec {
  name = "libykneomgr-0.1.8";

  src = fetchurl {
    url = "https://developers.yubico.com/libykneomgr/Releases/${name}.tar.gz";
    sha256 = "12gqblz400kr11m1fdr1vvwr85lgy5v55zy0cf782whpk8lyyj97";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcsclite libzip help2man ];

  configureFlags = [
    "--with-backend=pcsc"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libykneomgr;
    description = "A C library to interact with the CCID-part of the Yubikey NEO";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
