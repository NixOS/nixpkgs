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
  version = "1.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cqpyy4jr3023c47ij08djkpx526gmz8fab45mcnws0glhp7xhms";
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
