{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  idasen,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "idasen-ha";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "idasen-ha";
    tag = version;
    hash = "sha256-Z4MfJGL2uDqY1ddoV2fB+Ty/dKFhCUY8qBfP/i/naJs=";
  };

  patches = [
    (fetchpatch {
      name = "bleak-1.0.0-compat.patch";
      url = "https://github.com/abmantis/idasen-ha/commit/57e5ba4affb99b17ffc95a33a0aec60c7518be2b.patch";
      hash = "sha256-Jc6e9uYrifXZ91aNhoxqyquq1WMzHWrVKPBXYhosbRM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ idasen ];

  pythonImportsCheck = [ "idasen_ha" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/abmantis/idasen-ha/releases/tag/${version}";
    description = "Home Assistant helper lib for the IKEA Idasen Desk integration";
    homepage = "https://github.com/abmantis/idasen-ha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
