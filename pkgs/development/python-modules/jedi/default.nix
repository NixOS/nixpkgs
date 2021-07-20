{ lib
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
, tox
, pytestcov
, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-klUKQEutiv7YgaE37JpGH+1J7KZhQUvkUFkylhTtBwc=";
  };

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  propagatedBuildInputs = [ parso ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # A few tests failed because of having to access home directory.
  # Therefore disable the tests for now.
  doCheck = false;

  pythonImportsCheck = [ "jedi" ];

  meta = with lib; {
    homepage = "https://github.com/davidhalter/jedi";
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
