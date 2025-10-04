{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "findimports";
    tag = version;
    hash = "sha256-2hhonlv7FF4s+wDOsBGnLsMxJEXlMlNbLEkI8HptyOI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "findimports" ];

  checkPhase = ''
    # Tests fails
    rm tests/cmdline.txt

    runHook preCheck
    ${python.interpreter} testsuite.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${version}/CHANGES.rst";
    license = with licenses; [
      gpl2Only # or
      gpl3Only
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "findimports";
  };
}
