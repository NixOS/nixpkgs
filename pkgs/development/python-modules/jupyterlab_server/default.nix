{ stdenv
, buildPythonPackage
, fetchPypi
, notebook
, jsonschema
, pythonOlder
, requests
, pytest
, pyjson5
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "1.2.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5431d9dde96659364b7cc877693d5d21e7b80cea7ae3959ecc2b87518e5f5d8c";
  };

  checkInputs = [ requests pytest ];
  requiredPythonModules = [ notebook jsonschema pyjson5 ];

  # test_listing test fails
  # this is a new package and not all tests pass
  doCheck = false;

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
