{
  lib,
  buildPythonPackage,
  flint,
  fetchPypi,
  gmpxx,
  normaliz,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "pynormaliz";
  version = "2.24";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HpHN8kxXxEcsuPAXD+kEHoNm/H1ZjsIUthefYjn4iZw=";
  };

  buildInputs = [
    flint
    gmpxx
    normaliz
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "PyNormaliz" ];

  meta = {
    description = "Python interface to Normaliz";
    homepage = "https://github.com/Normaliz/PyNormaliz";
    changelog = "https://github.com/Normaliz/PyNormaliz/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kilianar ];
  };
}
