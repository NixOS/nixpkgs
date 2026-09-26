{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # test framework
  pytestCheckHook,

  # dependencies
  matplotlib,
  numpy,
  pandas,
  pandas-flavor,
  scikit-learn,
  scipy,
  seaborn,
  statsmodels,
  tabulate,

  # optional dependencies
  mpmath,
}:

buildPythonPackage (finalAttrs: {
  pname = "pingouin";
  version = "0.6.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "raphaelvallat";
    repo = "pingouin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22nVAw6qbYwumwVJr/ZZD2HSpgD+9onnMe/hULjQHZI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
    pandas
    pandas-flavor
    scikit-learn
    scipy
    seaborn
    statsmodels
    tabulate
  ];

  passthru.optional-dependencies = {
    extras = [
      mpmath
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.extras;

  pythonImportsCheck = [
    "pingouin"
  ];

  meta = {
    description = "Statistical package in Python based on Pandas";
    homepage = "https://github.com/raphaelvallat/pingouin";
    changelog = "https://github.com/raphaelvallat/pingouin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ grandjeanlab ];
  };
})
