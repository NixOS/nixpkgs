{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libiconv,
  pandas,
  python,
  pythonOlder,
  readstat,
  setuptools,
  zlib,
}:

buildPythonPackage rec {
  pname = "pyreadstat";
  version = "1.2.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    tag = "v${version}";
    hash = "sha256-4SdA4yYf3ha42ktyObTa2eOG16sq5tq+7Iyi16V00bw=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [
    readstat
    pandas
  ];

  pythonImportsCheck = [ "pyreadstat" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test_basic.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Module to read SAS, SPSS and Stata files into pandas data frames";
    homepage = "https://github.com/Roche/pyreadstat";
    changelog = "https://github.com/Roche/pyreadstat/blob/${src.tag}/change_log.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ swflint ];
  };
}
