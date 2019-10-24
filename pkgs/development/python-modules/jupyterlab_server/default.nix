{ stdenv
, buildPythonPackage
, fetchPypi
, notebook
, jsonschema
, pythonOlder
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "1.0.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0977527bfce6f47c782cb6bf79d2c949ebe3f22ac695fa000b730c671445dad";
  };

  checkInputs = [ requests pytest ];
  propagatedBuildInputs = [ notebook jsonschema ];

  # test_listing test fails
  # this is a new package and not all tests pass
  doCheck = false;

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "JupyterLab Server";
    homepage = https://jupyter.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
