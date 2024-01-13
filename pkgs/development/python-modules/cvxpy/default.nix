{ lib
, stdenv
, buildPythonPackage
, cvxopt
, ecos
, fetchPypi
, fetchpatch
, numpy
, osqp
, pytestCheckHook
, pythonOlder
, scipy
, scs
, setuptools
, wheel
, pybind11
, useOpenmp ? (!stdenv.isDarwin)
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ep7zTjxX/4yETYbwo4NPtVda8ZIzlHY53guld8YSLj4=";
  };

  patches = [
    (fetchpatch {  #https://github.com/cvxpy/cvxpy/pull/2234
      name = "add-support-for-bounds";
      url = "https://github.com/cvxpy/cvxpy/commit/113fd03969d95679ba2ea6eae7ffb43125ebcae8.patch";
      hash = "sha256-zdBelWrRew0ggAEtvErqz9ILxsZDquUa6iA808qQjh0=";
      excludes = [
        "doc/source/tutorial/advanced/index.rst"
      ];
    })
  ];

  # we need to patch out numpy version caps from upstream
  postPatch = ''
    sed -i 's/\(numpy>=[0-9.]*\),<[0-9.]*;/\1;/g' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    wheel
    pybind11
  ];

  propagatedBuildInputs = [
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Required flags from https://github.com/cvxpy/cvxpy/releases/tag/v1.1.11
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

  pytestFlagsArray = [
    "cvxpy"
  ];

  disabledTests = [
   # Disable the slowest benchmarking tests, cuts test time in half
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
    "test_huber"
    "test_partial_problem"
    # https://github.com/cvxpy/cvxpy/issues/2174
    "test_scipy_mi_time_limit_reached"
  ] ++ lib.optionals stdenv.isAarch64 [
    "test_ecos_bb_mi_lp_2" # https://github.com/cvxpy/cvxpy/issues/1241#issuecomment-780912155
  ];

  pythonImportsCheck = [
    "cvxpy"
  ];

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxpy/cvxpy//releases";
    changelog = "https://github.com/cvxpy/cvxpy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
