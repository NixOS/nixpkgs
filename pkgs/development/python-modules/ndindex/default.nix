{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

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
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "ndindex";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-rjhCysdhLCAofob7yUL7s65hMju13uotrzJ+aY0stzI=";
=======
    hash = "sha256-gPhRln7cUoRmypuTDTwoz4LyCBX3EwuKes/SEoz9NYM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cython
    setuptools
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--flakes" ""
  '';

  optional-dependencies.arrays = [ numpy ];

  pythonImportsCheck = [ "ndindex" ];

  # fix Hypothesis timeouts
  preCheck = ''
    cd $out

    echo > ${python.sitePackages}/ndindex/tests/conftest.py <<EOF

    import hypothesis

    hypothesis.settings.register_profile(
      "ci",
      deadline=None,
      print_blob=True,
      derandomize=True,
    )
    EOF
  '';

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
    sympy
  ]
  ++ optional-dependencies.arrays;

  pytestFlags = [
    "--hypothesis-profile=ci"
  ];

<<<<<<< HEAD
  meta = {
    description = "Python library for manipulating indices of ndarrays";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${src.tag}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python library for manipulating indices of ndarrays";
    homepage = "https://github.com/Quansight-Labs/ndindex";
    changelog = "https://github.com/Quansight-Labs/ndindex/releases/tag/${src.tag}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
