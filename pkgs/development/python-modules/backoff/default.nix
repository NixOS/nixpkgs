{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, poetry, pytest-asyncio, }:

buildPythonPackage rec {
  pname = "backoff";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "litl";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jj0l6pjx747d2yyvnzd3qbm4qr73sq6cc56dhvd8wqfbp5279x0";
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
