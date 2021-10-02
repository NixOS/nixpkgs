{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, poetry, pytest-asyncio, }:

buildPythonPackage rec {
  pname = "backoff";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "litl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-87IMcLaoCn0Vns8Ub/AFmv0gXtS0aPZX0cSt7+lOPm4=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  checkInputs = [ pytestCheckHook pytest-asyncio ];

  meta = with lib; {
    description = "Function decoration for backoff and retry";
    homepage = "https://github.com/litl/backoff";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
