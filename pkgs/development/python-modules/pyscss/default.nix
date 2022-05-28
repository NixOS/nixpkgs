{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, six
, enum34
, pathlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyScss";
  version = "1.4.0";

  src = fetchFromGitHub {
    repo = "pyScss";
    owner = "Kronuz";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-z0y4z+/JE6rZWHAvps/taDZvutyVhxxs2gMujV5rNu4=";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ six ]
    ++ lib.optionals (pythonOlder "3.4") [ enum34 pathlib ];

  # Test suite is broken.
  # See https://github.com/Kronuz/pyScss/issues/415
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "A Scss compiler for Python";
    homepage = "https://pyscss.readthedocs.org/en/latest/";
    license = licenses.mit;
  };

}
