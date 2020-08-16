{ lib, buildPythonPackage, fetchPypi
, hypothesis
, poetry
, pydantic
, pytest
}:

buildPythonPackage rec {
  pname = "hypothesis-auto";
  version = "1.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9jksza0gg2gva3liy0s8riv6imjavhnqw05m8l5660knq2yb2y";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    pydantic
    hypothesis
    pytest
  ];

  pythonImportsCheck = [ "hypothesis_auto" ];

  meta = with lib; {
    description = "Enables fully automatic tests for type annotated functions";
    homepage = "https://github.com/timothycrosley/hypothesis-auto/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
