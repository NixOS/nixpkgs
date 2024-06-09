{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  wcwidth,
  pytest,
  mock,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.20.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LN1n+HRuBI8A30eiiA9NasvNs5kDG2BONLqPcdV4doA=";
  };

  nativeCheckInputs = [
    pytest
    mock
    glibcLocales
  ];

  # Default tox.ini parameters not needed
  checkPhase = ''
    rm tox.ini
    pytest
  '';

  propagatedBuildInputs = [
    wcwidth
    six
  ];

  meta = with lib; {
    homepage = "https://github.com/jquast/blessed";
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
