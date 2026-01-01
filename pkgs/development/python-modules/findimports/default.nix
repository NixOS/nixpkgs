{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "findimports";
    tag = version;
    hash = "sha256-ztbf9F1tz5EhqSkE8W6i7ihJYJTymKQdXI+K/G7DbHM=";
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

<<<<<<< HEAD
  meta = {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${src.tag}/CHANGES.rst";
    license = with lib.licenses; [
      gpl2Only # or
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${src.tag}/CHANGES.rst";
    license = with licenses; [
      gpl2Only # or
      gpl3Only
    ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "findimports";
  };
}
