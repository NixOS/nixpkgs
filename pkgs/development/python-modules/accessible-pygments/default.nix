{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pygments
}:

buildPythonPackage rec {
  pname = "accessible-pygments";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CRe1B2RqazOT60kJGmJQb2sqOTX12V5NEkncUF+KTq4=";
  };

  propagatedBuildInputs = [
    pygments
  ];

  # Tests only execute pygments with these styles
  doCheck = false;

  pythonImportsCheck = [
    "a11y_pygments"
    "a11y_pygments.utils"
  ];

  meta = with lib; {
    description = "A collection of accessible pygments styles";
    homepage = "https://github.com/Quansight-Labs/accessible-pygments";
    changelog = "https://github.com/Quansight-Labs/accessible-pygments/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
