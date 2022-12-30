{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, runCommandNoCC
, clang_12
, python
, graphviz, matplotlib, numpy, pandas, plotly, scipy, six
, withCuda ? false
, cudatoolkit
}:

buildPythonPackage rec {
  pname = "catboost";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = "catboost";
    rev = "v${version}";
    hash = "sha256-bqnUHTTRan/spA5y4LRt/sIUYpP3pxzdN/4wHjzgZVY=";
  };

  ya = runCommandNoCC "ya-bin" {
    inherit src;
    YA_CACHE_DIR="./";
    outputHashMode = "flat";
    outputHash = {
      aarch64-darwin = "sha256-FbwQ0fLAxsfX/lyupvCj5myQN8oiEE4R+CJMR1GRkFU=";
      x86_64-darwin = "sha256-2t3JNm+X+CHuD3ZDQUqgPgP54FzSS+TQ3iiiapjFctE=";
      x86_64-linux = "sha256-7Nw6tyCTGf/Kvc+NtG4qFvvIEgg5BYbINrIXVUQnrB4=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
    nativeBuildInputs = [ python ];
  } ''
    python $src/ya
    install -Dm444 tools/*/ya-bin $out
  '';

  nativeBuildInputs = [
    clang_12
  ];

  propagatedBuildInputs = [ graphviz matplotlib numpy pandas scipy plotly six ]
    ++ lib.optionals withCuda [ cudatoolkit ];

  preBuild = ''
    export YA_SOURCE_ROOT="$PWD"

    cd catboost/python-package

    cp "$ya" ./ya-bin
    chmod +x ./ya-bin
    wrapProgram ./ya-bin \
      --unset PYTHONPATH \
      --set YA_CACHE_DIR "./"

    substituteInPlace setup.py \
      --replace "python, ya, " "'./ya-bin', '-v', " \
      --replace "_catboost.dylib" "_catboost.so"

    # ImportError: cannot import name '_catboost' from partially initialized module 'catboost'
    export PYTHONPATH="$PYTHONPATH":
  '';

  # recover PYTHONPATH to avoid failing in pythonCatchConflictsPhase
  postInstall = ''
    export PYTHONPATH="''${PYTHONPATH%%:}"
  '';

  CUDA_ROOT = lib.optional withCuda cudatoolkit;
  enableParallelBuilding = true;

  # No documented way to run tests
  doCheck = false;
  pythonImportsCheck = [ "catboost" ];

  meta = with lib; {
    description = "High-performance library for gradient boosting on decision trees.";
    longDescription = ''
      A fast, scalable, high performance Gradient Boosting on Decision Trees
      library, used for ranking, classification, regression and other machine
      learning tasks for Python, R, Java, C++. Supports computation on CPU and GPU.
    '';
    license = licenses.asl20;
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    homepage = "https://catboost.ai";
    maintainers = with maintainers; [ PlushBeaver veprbl ];
  };
}
