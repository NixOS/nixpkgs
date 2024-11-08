{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # optional
  numpy,

  # tests
  hypothesis,
  pytest-cov-stub,
  pytestCheckHook,
  sympy,
}:

buildPythonPackage rec {
  pname = "ndindex";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    rev = "refs/tags/${version}";
    hash = "sha256-5S4HN5MFLgURImwFsyyTOxDhrZJ5Oe+Ln/TA/bsCsek=";
  };

  build-system = [
    cython
    setuptools
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flakes" ""
  '';

  optional-dependencies.arrays = [ numpy ];

  pythonImportsCheck = [ "ndindex" ];

  preCheck = ''
    cd $out
  '';

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
    sympy
  ] ++ optional-dependencies.arrays;

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
