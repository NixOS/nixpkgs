{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "heatzypy";
  version = "2.1.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = "heatzypy";
    rev = "refs/tags/${version}";
    hash = "sha256-O2HtCaNtBvjhjlSXLRhEuilI8z7nGgzFa8USYiHfZ+E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "replace_by_workflow" "${version}"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "heatzypy"
  ];

  meta = with lib; {
    description = "Module to interact with Heatzy devices";
    homepage = "https://github.com/Cyr-ius/heatzypy";
    changelog = "https://github.com/cyr-ius/heatzypy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
