{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  mock,
  fetchpatch,
  python,
}:

buildPythonPackage rec {
  pname = "contexttimer";
  version = "unstable-2019-03-30";
  format = "setuptools";

  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "brouberol";
    repo = "contexttimer";
    rev = "a866f420ed4c10f29abf252c58b11f9db6706100";
    hash = "sha256-Fc1vK1KSZWgBPtBf5dVydF6dLHEGAOslWMV0FLRdj8w=";
  };

  patches = [
    # https://github.com/brouberol/contexttimer/pull/16
    (fetchpatch {
      url = "https://github.com/brouberol/contexttimer/commit/dd65871f3f25a523a47a74f2f5306c57048592b0.patch";
      hash = "sha256-vNBuFXvuvb6hWPzg4W4iyKbd4N+vofhxsKydEkc25E4=";
    })
  ];

  pythonImportsCheck = [ "contexttimer" ];

  nativeCheckInputs = [ mock ];

  checkPhase = ''
    ${python.interpreter} -m unittest tests/test_timer.py
  '';

  meta = with lib; {
    homepage = "https://github.com/brouberol/contexttimer";
    description = "A timer as a context manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
  };
}
