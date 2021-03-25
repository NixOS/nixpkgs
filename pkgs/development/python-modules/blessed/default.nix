{ lib, buildPythonPackage, fetchPypi, fetchpatch, six
, wcwidth, pytest, mock, glibcLocales
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.17.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "580429e7e0c6f6a42ea81b0ae5a4993b6205c6ccbb635d034b4277af8175753e";
  };

  checkInputs = [ pytest mock glibcLocales ];

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
