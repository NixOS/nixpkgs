{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, isPyPy
, fetchPypi
, postgresql
, openssl
, sphinxHook
, sphinx-better-theme
}:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.9.7";
  format = "setuptools";

  # Extension modules don't work well with PyPy. Use psycopg2cffi instead.
  # c.f. https://github.com/NixOS/nixpkgs/pull/104151#issuecomment-729750892
  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8AzDW9cRnx/tF7hb0QB4VRlN3iy9jeAauOuxdIdECtg=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [
    postgresql
    sphinxHook
    sphinx-better-theme
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    openssl
  ];

  sphinxRoot = "doc/src";

  # Requires setting up a PostgreSQL database
  doCheck = false;

  pythonImportsCheck = [
    "psycopg2"
  ];

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    homepage = "https://www.psycopg.org";
    license = with licenses; [ lgpl3Plus zpl20 ];
    maintainers = with maintainers; [ ];
  };
}
