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
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ndindex";
  version = "1.9.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
    hash = "sha256-5S4HN5MFLgURImwFsyyTOxDhrZJ5Oe+Ln/TA/bsCsek=";
  };

  nativeBuildInputs = [ cython ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flakes" ""
  '';

  optional-dependencies.arrays = [ numpy ];

  pythonImportsCheck = [ "ndindex" ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ] ++ optional-dependencies.arrays;

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
