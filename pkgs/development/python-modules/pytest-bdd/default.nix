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
  version = "4.0.1";

  # tests are not included in pypi tarball
  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = version;
    sha256 = "1yqzz44as4pxffmg4hk9lijvnvlc2chg1maq1fbj5i4k4jpagvjz";
  };

  propagatedBuildInputs = [ glob2 Mako parse parse-type py pytest six ];

  # Tests require extra dependencies
  checkInputs = [ execnet mock pytest ];
  checkPhase = ''
    PATH=$PATH:$out/bin pytest
  '';

  meta = with stdenv.lib; {
    description = "BDD library for the py.test runner";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
