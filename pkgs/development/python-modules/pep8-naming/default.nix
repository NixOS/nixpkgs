{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flake8
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "sha256-NG4hLZcOMKprUyMnzkHRmUCFGyYgvT6ydBQNpgWE9h0=";
  };

  patches = [
    # Fixes tests for flake8 => 5
    # Remove on next release
    (fetchpatch {
      url = "https://github.com/PyCQA/pep8-naming/commit/c8808a0907f64b5d081cff8d3f9443e5ced1474e.patch";
      sha256 = "sha256-4c+a0viS0rXuxj+TuIfgrKZjnrjiJjDoYBbNp3+6Ed0=";
    })
  ];

  propagatedBuildInputs = [
    flake8
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pep8ext_naming"
  ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pep8-naming";
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
