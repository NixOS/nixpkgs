{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "pyscss";
  version = "1.4.0";

  src = fetchFromGitHub {
    repo = "pyScss";
    owner = "Kronuz";
    rev = "refs/tags/v${version}";
    hash = "sha256-z0y4z+/JE6rZWHAvps/taDZvutyVhxxs2gMujV5rNu4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ six ];

  # Test suite is broken.
  # See https://github.com/Kronuz/pyScss/issues/415
  doCheck = false;

  meta = with lib; {
    description = "Scss compiler for Python";
    homepage = "https://pyscss.readthedocs.org/en/latest/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
