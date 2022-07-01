{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cudatoolkit
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "11.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2e4a33b80569d093b513f5804db0c7f40cfc86f15a013ae7a8e99c5e175d5dd";
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
