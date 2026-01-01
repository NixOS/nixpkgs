{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rangeparser";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "RangeParser";
    inherit version;
    hash = "sha256-gjA7Iytg802Lv7/rLfhGE0yjz4e6FfOXbEoWNPjhCOY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rangeparser" ];

<<<<<<< HEAD
  meta = {
    description = "Parses ranges";
    homepage = "https://pypi.org/project/RangeParser/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Parses ranges";
    homepage = "https://pypi.org/project/RangeParser/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
