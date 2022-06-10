{ lib
, buildPythonPackage
, fetchPypi
, pydocstyle
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-pydocstyle";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Hy2Tc0nP60llxTCgwPJEK0jAMplVjbQ1tlVJcZUQ0ys=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pydocstyle
  ];

  meta = with lib; {
    description = "pytest plugin to run pydocstyle";
    homepage = "https://github.com/henry0312/pytest-pydocstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
