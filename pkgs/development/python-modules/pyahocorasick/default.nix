{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "1.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "WojciechMula";
    repo = pname;
    rev = version;
    hash = "sha256-X6ifwOwf7GAaNUxInKhR3NX6hKhvFMkvfbK6XpH8CBo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "unittests.py"
  ];

  pythonImportsCheck = [
    "ahocorasick"
  ];

  meta = with lib; {
    description = "Python module implementing Aho-Corasick algorithm";
    longDescription = ''
      This Python module is a fast and memory efficient library for exact or
      approximate multi-pattern string search meaning that you can find multiple
      key strings occurrences at once in some input text.
    '';
    homepage = "https://github.com/WojciechMula/pyahocorasick";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
