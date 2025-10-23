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
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilohuang";
    repo = "PyTurboJPEG";
    tag = "v${version}";
    hash = "sha256-zyLNIo7hQuzTlEgdvri3bSnAiRRKKup57tfCIxiBq24=";
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
    changelog = "https://github.com/lilohuang/PyTurboJPEG/releases/tag/${src.tag}";
    description = "Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
