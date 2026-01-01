{
  lib,
  buildPythonPackage,
  fetchPypi,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "py3nvml";
  version = "0.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ce4dBFmKbmZOJEZfgEzjv+EZpv21Ni3xwWj4qpKfvXM=";
  };

  propagatedBuildInputs = [ xmltodict ];

  pythonImportsCheck = [ "py3nvml" ];

<<<<<<< HEAD
  meta = {
    description = "Python 3 Bindings for the NVIDIA Management Library";
    mainProgram = "py3smi";
    homepage = "https://pypi.org/project/py3nvml/";
    license = with lib.licenses; [
      bsd3
      bsd2
    ];
    maintainers = with lib.maintainers; [ happysalada ];
=======
  meta = with lib; {
    description = "Python 3 Bindings for the NVIDIA Management Library";
    mainProgram = "py3smi";
    homepage = "https://pypi.org/project/py3nvml/";
    license = with licenses; [
      bsd3
      bsd2
    ];
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
