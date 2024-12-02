{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libjpeg_turbo,
  setuptools,
  numpy,
  python,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "pyturbojpeg";
  version = "1.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilohuang";
    repo = "PyTurboJPEG";
    rev = "refs/tags/v${version}";
    hash = "sha256-JPjGZGVMZH6sDNRdV6kWsCpEjLT2aMrTy+bI4mRbdpw=";
  };

  patches = [
    (substituteAll {
      src = ./lib-path.patch;
      libturbojpeg = "${lib.getLib libjpeg_turbo}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # upstream has no tests, but we want to test whether the library is found
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -c 'from turbojpeg import TurboJPEG; TurboJPEG()'

    runHook postCheck
  '';

  pythonImportsCheck = [ "turbojpeg" ];

  meta = with lib; {
    changelog = "https://github.com/lilohuang/PyTurboJPEG/releases/tag/v${version}";
    description = "Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
