{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, poetry, pytest-asyncio, responses }:

buildPythonPackage rec {
  pname = "backoff";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "litl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-eKd1g3UxXlpSlNlik80RKXRaw4mZyvAWl3i2GNuZ3hI=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  checkInputs = [ pytestCheckHook pytest-asyncio responses ];

  meta = with lib; {
    description = "Function decoration for backoff and retry";
    homepage = "https://github.com/litl/backoff";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
