{ lib, stdenv, fetchurl, cmake, openssl, pcsclite, opensc, libxml2, Security }:

stdenv.mkDerivation rec {

  version = "3.10.5";
  pname = "libdigidoc";

  src = fetchurl {
    url = "https://github.com/open-eid/libdigidoc/releases/download/v${version}/libdigidoc-${version}.tar.gz";
    sha256 = "0nw36a4i6rcq7z6jqz5h2ln9hmmsfhw65jga3rymlswk2k7bndgn";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl pcsclite opensc libxml2 ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  cmakeFlags = lib.optionals stdenv.isDarwin [ "-DFRAMEWORK=OFF" ];

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "https://github.com/open-eid/libdigidoc";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jagajaga ];
  };
}
