{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libjpeg_turbo,
  setuptools,
  numpy,
  python,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "pyturbojpeg";
  version = "1.7.3";
  pyproject = true;

  src = fetchPypi {
    pname = "PyTurboJPEG";
    inherit version;
    hash = "sha256-edSOOrU0YVKP+4AJxCCYnQh6iewxVFTM1QmU88mukis=";
  };

  patches = [
    (substituteAll {
      src = ./lib-path.patch;
      libturbojpeg = "${libjpeg_turbo.out}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  # upstream has no tests, but we want to test whether the library is found
  checkPhase = ''
    ${python.interpreter} -c 'from turbojpeg import TurboJPEG; TurboJPEG()'
  '';

  pythonImportsCheck = [ "turbojpeg" ];

  meta = with lib; {
    description = "A Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
