{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyannotate
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-annotate";
  version = "1.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CSaTIPjSGHKCR0Nvet6W8zzz/oWEC0BjIULZ+JaMH9A=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pyannotate
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest>=3.2.0,<7.0.0" "pytest>=3.2.0"
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pytest_annotate"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Generate PyAnnotate annotations from your pytest tests";
    homepage = "https://github.com/kensho-technologies/pytest-annotate";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
