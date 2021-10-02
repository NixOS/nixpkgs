{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cudatoolkit
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "11.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1fxKItNVtAw0HWugqoiKLU0iUxd9JDkA+EAbfmyssbs=";
  };

  propagatedBuildInputs = [ cudatoolkit ];

  doCheck = false;  # no tests in PyPi dist
  pythonImportsCheck = [ "pynvml" "pynvml.smi" ];

  meta = with lib; {
    description = "Python bindings for the NVIDIA Management Library";
    homepage = "https://www.nvidia.com";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
