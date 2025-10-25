{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyspeex-noise";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyspeex-noise";
    tag = "v${version}";
    hash = "sha256-sOm3zYXI84c/8Qh4rvEZGcBo/avqS+ul+uLwtmCCc1I=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "pyspeex_noise" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/rhasspy/pyspeex-noise/blob/${src.tag}/CHANGELOG.md";
    description = "Noise suppression and automatic gain with speex";
    homepage = "https://github.com/rhasspy/pyspeex-noise";
    license = with lib.licenses; [
      mit # pyspeex-noise
      bsd3 # speex (vendored)
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
