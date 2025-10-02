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
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mir-evaluation";
    repo = "mir_eval";
    tag = version;
    hash = "sha256-Dq/kqoTY8YGATsr6MSgfQxkWvFpmH/Pf1pKBLPApylY=";
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
  ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    pushd tests
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "mir_eval" ];

  meta = with lib; {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
