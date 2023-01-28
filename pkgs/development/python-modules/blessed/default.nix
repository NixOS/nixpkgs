{ lib, buildPythonPackage, fetchPypi, six
, wcwidth, pytest, mock, glibcLocales
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.19.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mg0JlpW/Yh1GgN1sc/atVH9qNEL72+gMSx2qHtvEkvw=";
  };

  nativeCheckInputs = [ pytest mock glibcLocales ];

  # Default tox.ini parameters not needed
  checkPhase = ''
    rm tox.ini
    pytest
  '';

  propagatedBuildInputs = [ wcwidth six ];

  meta = with lib; {
    homepage = "https://github.com/jquast/blessed";
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
