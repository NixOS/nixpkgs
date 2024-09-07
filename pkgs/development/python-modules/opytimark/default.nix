{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "opytimark";
  version = "1.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gugarosa";
    repo = "opytimark";
    rev = "v${version}";
    hash = "sha256-T3OFm10gvGrUXAAHOnO0Zv1nWrXPBXSmEWnbJxrWYU0=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/gugarosa/opytimark/pull/2.patch";
      hash = "sha256-r/oCKI9Q1nuCZDGHx7UW8j523sFe4EFmguMOJTs/LOU=";
    })
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # several tests are failing
  disabledTests = [
    "test_year"
    "test_decorator"
    "test_loader"
    "cec_benchmark"
  ];

  pythonImportsCheck = [ "opytimark" ];

  meta = with lib; {
    description = "Library consisting of optimization benchmarking functions";
    homepage = "https://github.com/gugarosa/opytimark";
    changelog = "https://github.com/gugarosa/opytimark/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
