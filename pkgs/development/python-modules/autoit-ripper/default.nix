{
  lib,
  buildPythonPackage,
  fetchPypi,
  pefile,
  setuptools,
}:

buildPythonPackage rec {
  pname = "autoit-ripper";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+BHWDkeVewoRUgaHln5TyoajpCvJiowCiC2dFYyp1MA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pefile ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "autoit_ripper" ];

  meta = {
    description = "Python module to extract AutoIt scripts embedded in PE binaries";
    mainProgram = "autoit-ripper";
    homepage = "https://github.com/nazywam/AutoIt-Ripper";
    changelog = "https://github.com/nazywam/AutoIt-Ripper/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
