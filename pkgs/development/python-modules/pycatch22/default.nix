{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pandas
}:

buildPythonPackage rec {
  pname = "pycatch22";
  version = "0.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "DynamicsAndNeuralSystems";
    repo = "pycatch22";
    rev = "v${version}";
    hash = "sha256-wjMklOzU9I3Y2HdZ+rOTiffoKda+6X9zwDsmB+HXrSY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pandas
  ];

  # This packages does not have real tests
  # But we can run this file as smoketest
  checkPhase = ''
    runHook preCheck

    python tests/testing.py

    runHook postCheck
  '';
  pythonImportsCheck = [ "pycatch22" ];

  meta = with lib; {
    description = "Python implementation of catch22";
    homepage = "https://github.com/DynamicsAndNeuralSystems/pycatch22";
    changelog = "https://github.com/DynamicsAndNeuralSystems/pycatch22/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
