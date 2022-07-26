{ lib
, buildPythonPackage
, fetchPypi
, pytest
, setuptools-scm
, isPy3k
, hatchling }:

buildPythonPackage rec {
  pname = "apipkg";
  version = "3.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+MAhra/JEyrC+6n9PFdoNl0KjBCqN1+xXjKfH86KXwE=";
  };

  buildInputs = [ hatchling ];
  nativeBuildInputs = [ setuptools-scm ];
  checkInputs = [ pytest ];

  # Failing tests on Python 3
  # https://github.com/pytest-dev/apipkg/issues/17
  checkPhase = let
    disabledTests = lib.optionals isPy3k [
      "test_error_loading_one_element"
      "test_aliasmodule_proxy_methods"
      "test_eagerload_on_bython"
    ];
    testExpression = lib.optionalString (disabledTests != [])
    "-k 'not ${lib.concatStringsSep " and not " disabledTests}'";
  in ''
    py.test ${testExpression}
  '';

  meta = with lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = licenses.mit;
  };
}
