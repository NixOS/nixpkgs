{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder
, clang_12, python
, graphviz, matplotlib, numpy, pandas, plotly, scipy, six
, withCuda ? false, cudatoolkit }:

buildPythonPackage rec {
  pname = "catboost";
  version = "1.1.1";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-bqnUHTTRan/spA5y4LRt/sIUYpP3pxzdN/4wHjzgZVY=";
  };

  nativeBuildInputs = [ clang_12 ];

  propagatedBuildInputs = [ graphviz matplotlib numpy pandas scipy plotly six ]
    ++ lib.optionals withCuda [ cudatoolkit ];

  patches = [
    ./nix-support.patch
  ];

  postPatch = ''
    # substituteInPlace is too slow for these large files, and the target has lots of numbers in it that change often.
    sed -e 's|\$(YMAKE_PYTHON3-.*)/python3|${python.interpreter}|' -i make/*.makefile
  '';

  preBuild = ''
    cd catboost/python-package
  '';
  setupPyBuildFlags = [ "--with-ymake=no" ];
  CUDA_ROOT = lib.optional withCuda cudatoolkit;
  enableParallelBuilding = true;

  # Tests use custom "ya" tool, not yet supported.
  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "catboost" ];

  meta = with lib; {
    description = "High-performance library for gradient boosting on decision trees.";
    longDescription = ''
      A fast, scalable, high performance Gradient Boosting on Decision Trees
      library, used for ranking, classification, regression and other machine
      learning tasks for Python, R, Java, C++. Supports computation on CPU and GPU.
    '';
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    homepage = "https://catboost.ai";
    maintainers = with maintainers; [ PlushBeaver ];
    # _catboost.pyx.cpp:226822:19: error: use of undeclared identifier '_PyGen_Send'
    broken = withCuda;
  };
}
