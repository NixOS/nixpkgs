{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
  soundfile,
  stdenv,
  unixtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyflac";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sonos";
    repo = "pyFLAC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PA9ARch1MwBhLlTIIM+pXHc10pg0PM/uEHfwQ5e5MNI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cffi
    numpy
    soundfile
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    unixtools.procps # for sysctl
  ];

  preCheck = ''
    rm -r pyflac
  '';

  pythonImportsCheck = [ "pyflac" ];

  meta = {
    description = "Wrapper for libFLAC";
    homepage = "https://github.com/sonos/pyFLAC/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
