{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dotty_dict";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6wA1o2KezYQ5emjx9C8elKvRw0V3oZzT6srTMe58uvA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    description = "Dictionary wrapper for quick access to deeply nested keys";
    homepage = "https://dotty-dict.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
