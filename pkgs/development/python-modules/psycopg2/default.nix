{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, isPyPy
, fetchPypi
, postgresql
, openssl
}:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.9.2";

  # Extension modules don't work well with PyPy. Use psycopg2cffi instead.
  # c.f. https://github.com/NixOS/nixpkgs/pull/104151#issuecomment-729750892
  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a84da9fa891848e0270e8e04dcca073bc9046441eeb47069f5c0e36783debbea";
  };

  nativeBuildInputs = [
    postgresql
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    openssl
  ];

  # requires setting up a postgresql database
  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    homepage = "https://www.psycopg.org";
    license = with licenses; [ lgpl3 zpl20 ];
  };
}
