{
  lib,
  async-timeout,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ld2410-ble";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "930913";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wQnE2hNT0UOnPJbHq1eayIO8g0XRZvEH6V19DL6RqoA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ld2410_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ld2410_ble" ];

  meta = with lib; {
    description = "Library for the LD2410B modules from HiLinks";
    homepage = "https://github.com/930913/ld2410-ble";
    changelog = "https://github.com/930913/ld2410-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
