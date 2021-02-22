{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytestcov
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "aiostream";
  version = "0.4.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wwnjrzkd61k3arxzk7yhg7cc1099bcwr5kz5n91ai6ma5ln139s";
  };

  checkInputs = [ pytestCheckHook pytestcov pytest-asyncio ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
