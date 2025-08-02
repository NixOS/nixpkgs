{
  buildPythonPackage,
  numpy,
  pybind11,
  fetchFromGitHub,
  python,
  lib,
}:

buildPythonPackage rec {
  pname = "pyvirtualcam";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "letmaik";
    repo = "pyvirtualcam";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-JG4VlUTix2ZZtGp2hASsH/ZiWPdLbzSsIWg1GidBRTQ=";
  };

  postPatch = ''
    export PYTHONPATH=$PYTHONPATH:${python}${python.sitePackages}
  '';

  pythonImportsCheck = [ "pyvirtualcam._native_linux_v4l2loopback" ];

  propagatedBuildInputs = [
    numpy
    pybind11
  ];

  doCheck = false; # tests depend on a virtual v4l device so can't run on the sandbox

  meta = {
    description = "Send frames to a virtual camera from Python";
    homepage = "https://github.com/letmaik/pyvirtualcam";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.lucasew ];
  };
}
