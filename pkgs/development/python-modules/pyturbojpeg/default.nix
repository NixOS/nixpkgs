{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libjpeg_turbo,
  setuptools,
  numpy,
  python,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "pyturbojpeg";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilohuang";
    repo = "PyTurboJPEG";
    tag = "v${version}";
    hash = "sha256-4DPkzHjEsVjioRNLZii/5gZIEbj8A8rNkL8UXUQsgdY=";
  };

  patches = [
    (replaceVars ./lib-path.patch {
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
