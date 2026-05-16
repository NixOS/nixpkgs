{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  attrs,
  expects,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "punq";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bobthemighty";
    repo = "punq";
    tag = "v${version}";
    hash = "sha256-gZD2LfHmb23VwjAwA2kUIfXRpZ7jPFM+nUBUMGQQt0I=";
  };

  postPatch = ''
    # Upstream pins setuptools_scm <3; nixpkgs ships 8.x. The modern API
    # is backwards-compatible for this package's usage.
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm >= 2.0.0, <3"' '"setuptools_scm"'
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    attrs
    expects
    pytestCheckHook
  ];

  pythonImportsCheck = [ "punq" ];

  meta = {
    changelog = "https://github.com/bobthemighty/punq/releases/tag/v${version}";
    description = "Unintrusive dependency injection library for Python";
    homepage = "https://github.com/bobthemighty/punq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sesav ];
  };
}
