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
  version = "2.9.1";

  # Extension modules don't work well with PyPy. Use psycopg2cffi instead.
  # c.f. https://github.com/NixOS/nixpkgs/pull/104151#issuecomment-729750892
  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z0v2d5gpgy0wf2ypqxv955c9k44yszd7r20km5s79yhy6k06lyy";
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
