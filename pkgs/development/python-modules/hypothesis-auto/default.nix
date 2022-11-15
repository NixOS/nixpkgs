{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, poetry
, pydantic
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hypothesis-auto";
  version = "1.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XiwvsJ3AmEJRLYBjC7eSNZodM9LARzrUfuI9oL6eMrE=";
  };

  postPatch = ''
    # https://github.com/timothycrosley/hypothesis-auto/pull/20
    substituteInPlace pyproject.toml \
      --replace 'pydantic = ">=0.32.2<2.0.0"' 'pydantic = ">=0.32.2, <2.0.0"' \
      --replace 'hypothesis = ">=4.36<6.0.0"' 'hypothesis = "*"'
  '';

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    pydantic
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "hypothesis_auto"
  ];

  meta = with lib; {
    description = "Enables fully automatic tests for type annotated functions";
    homepage = "https://github.com/timothycrosley/hypothesis-auto/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
