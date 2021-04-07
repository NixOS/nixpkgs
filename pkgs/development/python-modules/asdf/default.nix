{ lib
, astropy
, buildPythonPackage
, fetchPypi
, jsonschema
, numpy
, packaging
, pytest-astropy
, pytestCheckHook
, pythonOlder
, pyyaml
, semantic-version
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "2.7.3";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11dyr295wn5m2pcynlwj7kgw9xr66msfvwn1m6a5vv13vzj19spp";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jsonschema
    numpy
    packaging
    pyyaml
    semantic-version
  ];

  checkInputs = [
    pytest-astropy
    astropy
    pytestCheckHook
  ];

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pythonImportsCheck = [ "asdf" ];

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/spacetelescope/asdf";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
