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
  version = "0.4.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ss41hzvlnyll5xc5ddxqyqqw4gnd67yyhci25xnb1vpcz0jqsq8";
  };

  checkInputs = [ pytestCheckHook pytestcov pytest-asyncio ];

  meta = with lib; {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
