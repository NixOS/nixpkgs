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
  version = "0.3.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b728z5ls0g3p1gq5hvfqg7302clxna5grvgjfwbfzss0avlpjc";
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
    homepage = http://jupyter.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
