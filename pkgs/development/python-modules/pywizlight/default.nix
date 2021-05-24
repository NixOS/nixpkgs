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
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = pname;
    rev = version;
    sha256 = "0zagdb90bxmf06fzpljhqgsgzg36zc1yhdibacfrx8bmnx3l657h";
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
