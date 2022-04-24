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
  version = "0.4.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "v${version}";
    sha256 = "07if27z1h0mg236sj9lc8nl0bqy9sdrj83ls73mrc69h76bzg5xi";
  };

  checkInputs = [ pytestCheckHook pytest-cov pytest-asyncio ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
