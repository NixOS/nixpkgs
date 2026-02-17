{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mplhep-data";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    pname = "mplhep_data";
    inherit version;
    hash = "sha256-TlxOrj5CN2LrPUrVQgYPG+fxIsGKFxZPf8/tz5Q/rH0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "mplhep_data" ];

  meta = {
    description = "Sub-package to hold data (fonts) for mplhep";
    homepage = "https://github.com/scikit-hep/mplhep_data";
    license = with lib.licenses; [
      mit
      gfl
      ofl
    ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
