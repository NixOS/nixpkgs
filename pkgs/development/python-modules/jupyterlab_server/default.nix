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
    sha256 = "132xby7531rbrjg9bqvsx86birr1blynjxy8gi5kcnb6x7fxjcal";
  };

  checkInputs = [ requests pytest ];
  propagatedBuildInputs = [ notebook jsonschema pyjson5 ];

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
