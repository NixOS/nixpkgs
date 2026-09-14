{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mplhep-data";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mplhep_data";
    inherit version;
    hash = "sha256-v5zcxlw6nOfY8OMHj/ZZ7z/P3hGeYloPcfIbBu2rxMk=";
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
