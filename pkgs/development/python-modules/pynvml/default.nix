{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cudatoolkit
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "8.0.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pfykj1amqh1rixp90rg85v1nj6qmx89fahqr6ii4zlcckffmm68";
  };

  propagatedBuildInputs = [ cudatoolkit ];

  doCheck = false;  # no tests in PyPi dist
  pythonImportsCheck = [ "pynvml" "pynvml.smi" ];

  meta = with lib; {
    description = "Python bindings for the NVIDIA Management Library";
    homepage = https://www.nvidia.com;
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
