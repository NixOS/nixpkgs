{ lib
, buildPythonPackage
, python3
, pythonOlder
, fetchFromGitHub
, hatchling
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyytlounge";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FabioGNR";
    repo = "pyytlounge";
    rev = "refs/tags/v${version}";
    hash = "sha256-4vV0Ip9qzihfCnaMU/XKPVxvA3KbfO+3dpo/rmolZ6c=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [ "pyytlounge" ];

  meta = with lib; {
    description = "YouTube Lounge API wrapper";
    homepage = "https://github.com/FabioGNR/pyytlounge";
    changelog = "https://github.com/FabioGNR/pyytlounge/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ jloyet ];
  };
}
