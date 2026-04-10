{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  astropy,
  numpy,
  matplotlib,
  scipy,
  six,

  # tests
  pytestCheckHook,
  pytest-astropy,
}:

buildPythonPackage (finalAttrs: {
  pname = "radio-beam";
  version = "0.3.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = "radio-beam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EO3tyT2wF3TeXDRCt7WUoSEd1s+umciGEkdgA4Bfmqs=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    astropy
    numpy
    scipy
    six
  ];

  nativeCheckInputs = [
    matplotlib
    pytest-astropy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radio_beam" ];

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    changelog = "https://github.com/radio-astro-tools/radio-beam/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
})
