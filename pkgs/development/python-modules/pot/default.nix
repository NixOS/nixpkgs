{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  scipy,
  eigen,

  # optional-dependencies
  # backend-jax
  jax,
  # backend-tf
  tensorflow,
  # backend-torch
  torch,
  torch-geometric,
  # cvxopt
  cvxopt,
  # dr
  scikit-learn,
  pymanopt,
  autograd,
  # plot
  matplotlib,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  python,
  cvxpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pot";
  version = "0.9.7.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PythonOT";
    repo = "POT";
    tag = finalAttrs.version;
    hash = "sha256-D1jFTYGQU4lW3aJ2KxJOPUu5KH2sVIoU7+PTWHXfmt0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail " --durations=20" "" \
      --replace-fail " --junit-xml=junit-results.xml" ""

    # we don't need setup.py to find the macos sdk for us
    sed -i '/sdk_path/d' setup.py

    # replace vendored eigen
    mkdir -p deps/eigen
    cp -r "${lib.getDev eigen}/include/eigen3" -T deps/eigen
  '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    eigen
  ];

  optional-dependencies = {
    backend-numpy = [ ];
    backend-jax = [ jax ];
    backend-cupy = [ ];
    backend-tf = [ tensorflow ];
    backend-torch = [ torch ];
    cvxopt = [ cvxopt ];
    dr = [
      scikit-learn
      pymanopt
      autograd
    ];
    gnn = [
      torch
      torch-geometric
    ];
    plot = [ matplotlib ];
    # geomloss = [ geomloss ];
    all = [
      jax
      tensorflow
      torch
      cvxopt
      scikit-learn
      pymanopt
      autograd
      torch-geometric
      matplotlib
      # geomloss
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    jax
    torch
    cvxopt
    scikit-learn
    autograd
    torch-geometric
    matplotlib
    cvxpy
  ]
  # tensorflow is broken on Python 3.14
  ++ lib.optionals (lib.versionOlder python.version "3.14") [
    tensorflow
    pymanopt
  ];

  # need to run the tests with the built package next to the test directory
  preCheck = ''
    pushd build/lib.*
    ln -s -t . "$OLDPWD/test"
  '';

  postCheck = ''
    popd
    rm -rf ot
  '';

  pythonImportsCheck = [
    "ot"
    "ot.bsp"
    "ot.lp"
    "ot.partial"
  ];

  meta = {
    description = "Python Optimal Transport Library";
    homepage = "https://pythonot.github.io/";
    downloadPage = "https://github.com/PythonOT/POT";
    changelog = "https://github.com/PythonOT/POT/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yl3dy
      stephen-huan
    ];
  };
})
