{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, fastprogress
, jax
, jaxlib
, jaxopt
, optax
, typing-extensions
}:

buildPythonPackage rec {
  pname = "blackjax";
  version = "0.9.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-EieDu9SJxi2cp1bHlxX4vvFZeDGMGIm24GoR8nSyjvE=";
  };

  patches = [
    # remove in next release
    (fetchpatch {
      name = "fix-lbfgs-args";
      url = "https://github.com/blackjax-devs/blackjax/commit/1aaa6f64bbcb0557b658604b2daba826e260cbc6.patch";
      hash = "sha256-XyjorXPH5Ap35Tv1/lTeTWamjplJF29SsvOq59ypftE=";
    })
  ];

  propagatedBuildInputs = [
    fastprogress
    jax
    jaxlib
    jaxopt
    optax
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [ "tests/test_benchmarks.py" ];
  disabledTests = [
    # too slow
    "test_adaptive_tempered_smc"
  ];

  pythonImportsCheck = [
    "blackjax"
  ];

  meta = with lib; {
    homepage = "https://blackjax-devs.github.io/blackjax";
    description = "Sampling library designed for ease of use, speed and modularity";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
