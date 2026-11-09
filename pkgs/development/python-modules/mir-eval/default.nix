{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  decorator,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mpl,
}:

buildPythonPackage rec {
  pname = "mir-eval";
  version = "0.8.2-unstable-2026-11-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mir-evaluation";
    repo = "mir_eval";
    # Switch back to `tag = version` once upstream releases a version with the
    # matplotlib 3.11 test baselines:
    # https://github.com/mir-evaluation/mir_eval/pull/440
    # tag = version;
    rev = "fc60fd435ecaf2bb05949938c39b130f17026c79";
    hash = "sha256-ZR7zzh+W7HVMKZ4lmJaTSbBUZp7UrO+PMy+0I2O7i8I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    numpy
    scipy
  ];

  optional-dependencies.display = [ matplotlib ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mpl
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    pushd tests
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "mir_eval" ];

  meta = {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ carlthome ];
  };
}
