{ lib
, asyncio-dgram
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywizlight";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XO9KmsC3DXgVcGWr5ss3m2wB8rVboWyQUWBidynhkP8=";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Tests requires network features (e. g., discovery testing)
  disabledTests = [
    "test_Bulb_Discovery"
    "test_timeout"
    "test_timeout_PilotBuilder"
  ];

  pythonImportsCheck = [ "pywizlight" ];

  meta = with lib; {
    description = "Python connector for WiZ light bulbs";
    homepage = "https://github.com/sbidy/pywizlight";
    changelog = "https://github.com/sbidy/pywizlight/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
