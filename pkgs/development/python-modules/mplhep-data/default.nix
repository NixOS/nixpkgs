{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mplhep-data";
  version = "0.0.4";
  format = "pyproject";

  src = fetchPypi {
    pname = "mplhep_data";
    inherit version;
    hash = "sha256-zR8606+dv/M67550BtITDWJKC9HVqllw/HE6ZCEWWk4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "mplhep_data" ];

  meta = with lib; {
    description = "Sub-package to hold data (fonts) for mplhep";
    homepage = "https://github.com/scikit-hep/mplhep_data";
    license = with licenses; [
      mit
      gfl
      ofl
    ];
    maintainers = with maintainers; [ veprbl ];
  };
}
