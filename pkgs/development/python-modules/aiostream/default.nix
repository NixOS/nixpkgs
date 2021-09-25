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
  version = "0.4.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r3x9qwl08yscmzvhafc6gsmq84lr17s6p7a1qxr49cmdvjzsc13";
  };

  checkInputs = [ pytestCheckHook pytest-cov pytest-asyncio ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
