{ stdenv, buildPythonPackage
, fetchFromGitHub
, six
, mock, pytest
}:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.6";

  # Pypi archives don't contain the tests
  src = fetchFromGitHub {
    owner = "DiffSK";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x97794nk3dfn0i3si9fv7y19jnpnarb34bkdwlz7ii7ag6xihhw";
  };


  propagatedBuildInputs = [ six ];

  checkPhase = ''
    pytest --deselect=tests/test_configobj.py::test_options_deprecation
  '';

  checkInputs = [ mock pytest ];

  meta = with stdenv.lib; {
    description = "Config file reading, writing and validation";
    homepage = https://pypi.python.org/pypi/configobj;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
