{ stdenv, buildPythonPackage, fetchFromGitHub
, execnet
, glob2
, Mako
, mock
, parse
, parse-type
, py
, pytest
, six
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "3.2.1";

  # tests are not included in pypi tarball
  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = version;
    sha256 = "02y28l5h1m9grj54p681qvv7nrhd7ly9jkqdchyw4p0lnmcmnsrd";
  };

  propagatedBuildInputs = [ glob2 Mako parse parse-type py pytest six ];

  # Tests require extra dependencies
  checkInputs = [ execnet mock pytest ];
  checkPhase = ''
    pytest
  '';
  
  meta = with stdenv.lib; {
    description = "BDD library for the py.test runner";
    homepage = https://github.com/pytest-dev/pytest-bdd;
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
