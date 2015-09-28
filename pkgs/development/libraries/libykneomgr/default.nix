{ stdenv, fetchurl, pkgconfig, pcsclite, libzip, help2man }:

stdenv.mkDerivation rec {
  name = "libykneomgr-0.1.7";

  src = fetchurl {
    url = "https://developers.yubico.com/libykneomgr/Releases/${name}.tar.gz";
    sha256 = "0nlzl9g0gjb54h43gjhg8d25bq3m3s794cq671irpqkn94kj1knw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcsclite libzip help2man ];

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
