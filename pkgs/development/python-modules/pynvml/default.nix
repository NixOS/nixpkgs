{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, pythonOlder
, addOpenGLRunpath
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "11.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0CeyG5WxCIufwngRf59ht8Z/jjOnh+n4P3NfD3GsMtA=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
      inherit (addOpenGLRunpath) driverLink;
    })
  ];


  doCheck = false;  # no tests in PyPi dist
  pythonImportsCheck = [ "pynvml" "pynvml.smi" ];

  meta = with lib; {
    description = "Python bindings for the NVIDIA Management Library";
    homepage = "https://www.nvidia.com";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
