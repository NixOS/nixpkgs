{
  lib,
  python3Packages,
  fetchPypi,
  mailman,
  nixosTests,
  buildPythonPackage,
  mozjpeg,
  cmake,
}:
buildPythonPackage rec {
  pname = "mozjpeg_lossless_optimization";
  version = "1.1.3";

  src = fetchPypi {
    inherit version;
    pname = "mozjpeg-lossless-optimization";
    sha256 = "sha256-cl2Ydy6UP8oYsIAcuU5kXEd/9S5WrQsnvdt23fCRyj4=";
  };

  # This package needs cmake, but it is not the default builder
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    mozjpeg
    cmake
  ];
  propagatedBuildInputs = [ python3Packages.cffi ];

  meta = with lib; {
    description = "Python library to optimize JPEGs losslessly using MozJPEG ";
    homepage = "https://github.com/wanadev/mozjpeg-lossless-optimization";
    license = licenses.bsd3;
    maintainers = with maintainers; [ adfaure ];
  };
}
