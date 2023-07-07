{ lib
, buildPythonPackage
, fetchFromGitHub
, marisa-trie
, poetry-core
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "language-data";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rspeer";
    repo = "language_data";
    rev = "v${version}";
    sha256 = "51TUVHXPHG6ofbnxI6+o5lrtr+QCIpGKu+OjDK3l7Mc=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    marisa-trie
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "language_data"
  ];

  meta = with lib; {
    description = "Supplement module for langcodes";
    homepage = "https://github.com/rspeer/language_data";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
