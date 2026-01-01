{
  lib,
  buildPythonPackage,
  crc16,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyoppleio";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S1w3pPqhX903kkXUq9ALz0+zRvNGOimLughRRVKjV8E=";
  };

  build-system = [ setuptools ];

  dependencies = [ crc16 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyoppleio" ];

<<<<<<< HEAD
  meta = {
    description = "Library for interacting with OPPLE lights";
    homepage = "https://github.com/jedmeng/python-oppleio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library for interacting with OPPLE lights";
    homepage = "https://github.com/jedmeng/python-oppleio";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "oppleio";
  };
}
