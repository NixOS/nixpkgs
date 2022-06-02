{ buildPythonPackage, fetchFromGitHub, fetchpatch, lib, pythonOlder
, clang_7, python2
, graphviz, matplotlib, numpy, pandas, plotly, scipy, six
, withCuda ? false, cudatoolkit }:

buildPythonPackage rec {
  pname = "catboost";
  version = "0.24.4";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    rev = "v${version}";
    sha256 = "sha256-pzmwEiKziB4ldnKgeCsP2HdnisX8sOkLssAzNfcSEx8=";
  };

  nativeBuildInputs = [ clang_7 python2 ];

  propagatedBuildInputs = [ graphviz matplotlib numpy pandas scipy plotly six ]
    ++ lib.optional withCuda [ cudatoolkit ];

  patches = [
    ./nix-support.patch
    (fetchpatch {
      name = "format.patch";
      url = "https://github.com/catboost/catboost/pull/1528/commits/a692ba42e5c0f62e5da82b2f6fccfa77deb3419c.patch";
      sha256 = "sha256-fNGucHxsSDFRLk3hFH7rm+zzTdDpY9/QjRs8K+AzVvo=";
    })
  ];

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
