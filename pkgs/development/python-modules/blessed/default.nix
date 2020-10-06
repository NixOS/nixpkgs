{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, six
, wcwidth, pytest, mock, glibcLocales
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.17.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09kcz6w87x34a3h4r142z3zgw0av19cxn9jrbz52wkpm1534dfaq";
  };

  checkInputs = [ pytest mock glibcLocales ];

  # Default tox.ini parameters not needed
  checkPhase = ''
    rm tox.ini
    pytest
  '';

  propagatedBuildInputs = [ wcwidth six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jquast/blessed";
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
