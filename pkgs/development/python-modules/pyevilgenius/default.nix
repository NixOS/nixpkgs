{ lib, aiohttp, buildPythonPackage, fetchFromGitHub, async-timeout, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyevilgenius";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "06xnl93sqklg7gx0z50vm79xwww0yyw05c1yynajc9aijfi8cmi3";
  };

  propagatedBuildInputs = [ aiohttp async-timeout ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "pyevilgenius" ];

  meta = with lib; {
    description = "Python SDK to interact with Evil Genius Labs devices";
    homepage = "https://github.com/home-assistant-libs/pyevilgenius";
    changelog =
      "https://github.com/home-assistant-libs/pyevilgenius/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
