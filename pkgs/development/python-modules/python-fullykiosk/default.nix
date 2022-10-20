{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-fullykiosk";
  version = "0.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Fndf9OOy3JLVTzHwfRzYrF/Khuhf9BMT6I+ze375p70=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "fullykiosk"
  ];

  meta = with lib; {
    description = "Wrapper for Fully Kiosk Browser REST interface";
    homepage = "https://github.com/cgarwood/python-fullykiosk";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
