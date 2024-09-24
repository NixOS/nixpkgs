{ lib
, buildDunePackage
, fetchurl
, eio
, ssl
}:

buildDunePackage rec {
  pname = "eio-ssl";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/eio-ssl/releases/download/${version}/eio-ssl-${version}.tbz";
    hash = "sha256-m4CiUQtXVSMfLthbDsAftpiOsr24I5IGiU1vv7Rz8go=";
  };

  propagatedBuildInputs = [ eio ssl ];

  meta = {
    homepage = "https://github.com/anmonteiro/eio-ssl";
    description = "OpenSSL binding to EIO";
    license = lib.licenses.lgpl21;
  };
}
