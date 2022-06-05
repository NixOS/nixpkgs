{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, importlib-metadata
, jaconv
, pytest-benchmark
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pykakasi";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = pname;
    rev = "v${version}";
    sha256 = "ivlenHPD00bxc0c9G368tfTEckOC3vqDB5kMQzHXbVM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaconv
    deprecated
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  disabledTests = [
    # We don't care about benchmarks
    "test_benchmark"
    "pytest_benchmark_update_machine_info"
    "pytest_benchmark_update_json"
  ];

  pythonImportsCheck = [
    "pykakasi"
  ];

  meta = with lib; {
    description = "Python converter for Japanese Kana-kanji sentences into Kana-Roman";
    homepage = "https://github.com/miurahr/pykakasi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
