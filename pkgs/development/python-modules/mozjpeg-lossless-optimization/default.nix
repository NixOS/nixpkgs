{
  lib,
  buildPythonPackage,
  cffi,
  cmake,
  fetchPypi,
  nasm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mozjpeg-lossless-optimization";
  version = "1.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "725d98772e943fca18b0801cb94e645c477ff52e56ad0b27bddb76ddf091ca3e";
  };

  dontConfigure = true; # cmake gets ran for some reason

  propagatedBuildInputs = [ cffi ];

  nativeBuildInputs = [
    cmake
    nasm
  ];

  # note: mozjpeg gets statically linked

  doCheck = false; # the tests use nox which isn't supported by nix yet. The checkInputs if a test is to be added are black, flake8, nox, and pytest

  pythonImportsCheck = [ "mozjpeg_lossless_optimization" ];

  meta = with lib; {
    description = "Optimize JPEGs losslessly using MozJPEG";
    homepage = "https://github.com/wanadev/mozjpeg-lossless-optimization";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
