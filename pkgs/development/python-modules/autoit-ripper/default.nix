{
  lib,
  buildPythonPackage,
  fetchPypi,
  pefile,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "autoit-ripper";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+BHWDkeVewoRUgaHln5TyoajpCvJiowCiC2dFYyp1MA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pefile ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "autoit_ripper" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python module to extract AutoIt scripts embedded in PE binaries";
    mainProgram = "autoit-ripper";
    homepage = "https://github.com/nazywam/AutoIt-Ripper";
    changelog = "https://github.com/nazywam/AutoIt-Ripper/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
