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
  version = "1.21.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Oi7xHWKuRdkUvTjpxnXAIjrVzl5jNVYLJ4F8qKDN+w=";
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
    description = "Thin, practical wrapper around terminal capabilities in Python";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
