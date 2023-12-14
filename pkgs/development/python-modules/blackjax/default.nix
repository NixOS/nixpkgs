{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, setuptools-scm
, fastprogress
, jax
, jaxlib
, jaxopt
, optax
, typing-extensions
}:

buildPythonPackage rec {
  pname = "blackjax";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hqOKSHyZ/BmOu6MJLeecD3H1BbLbZqywmlBzn3xjQRk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
    changelog = "https://github.com/blackjax-devs/blackjax/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
