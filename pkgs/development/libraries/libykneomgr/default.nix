{ stdenv, fetchurl, pkgconfig, pcsclite, libzip, help2man }:

stdenv.mkDerivation rec {
  name = "libykneomgr-0.1.6";

  src = fetchurl {
    url = "https://developers.yubico.com/libykneomgr/Releases/${name}.tar.gz";
    sha256 = "15fa4sslbzhzmkf0xik36as9lsmys1apqwjxv8sx7qlpacmxy3bw";
  };

  buildInputs = [ pkgconfig pcsclite libzip help2man ];

  configureFlags = [
    "--with-backend=pcsc"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libykneomgr;
    description = "a C library to interact with the CCID-part of the Yubikey NEO";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
