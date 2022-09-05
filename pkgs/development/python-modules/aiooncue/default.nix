{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiooncue";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    hash = "sha256-/Db32OomEkrBtq5lfT8zBGgvaUWnWE/sTqwNVNB9XAg=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module doesn't have tests
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [
    "aiooncue"
  ];

  meta = with lib; {
    description = "Module to interact with the Kohler Oncue API";
    homepage = "https://github.com/bdraco/aiooncue";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
