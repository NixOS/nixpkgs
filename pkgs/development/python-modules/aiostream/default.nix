{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytest-cov
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "aiostream";
  version = "0.4.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WOtscg02Dq5YNSAfq4pIyH3oUP/5G+cjBwKB6c+SUVA=";
  };

  nativeCheckInputs = [ pytestCheckHook pytest-cov pytest-asyncio ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
