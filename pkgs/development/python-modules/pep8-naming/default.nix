{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, flake8
, flake8-polyfill
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uyRVlHdX0WKqTK1V26TOApAFzRaS8omaIdUdhjDKeEE=";
  };

  propagatedBuildInputs = [
    flake8
    flake8-polyfill
  ];

  patches = [
    # Add missing option to get passing tests, https://github.com/PyCQA/pep8-naming/pull/181
    (fetchpatch {
      name = "add-missing-option.patch";
      url = "https://github.com/PyCQA/pep8-naming/commit/03b8f36f6a8bb8bc79dfa5a71ad9be2a0bf8bbf5.patch";
      sha256 = "1YTh84Yoj0MqFZoifM362563r1GuzaF+mMmdT/ckC7I=";
    })
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
