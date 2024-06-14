{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,

  # optional
  numpy,

  # tests
  hypothesis,
  pytest-cov,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ndindex";
  version = "1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
    hash = "sha256-F52ly3NkrZ0H9XoomMqmWfLl+8X0z26Yx67DB8DUqyU=";
  };

  nativeBuildInputs = [ cython ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=ndindex/ --cov-report=term-missing --flakes" ""
  '';

  passthru.optional-dependencies.arrays = [ numpy ];

  pythonImportsCheck = [ "ndindex" ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov # uses cov markers
    pytestCheckHook
  ] ++ passthru.optional-dependencies.arrays;

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
