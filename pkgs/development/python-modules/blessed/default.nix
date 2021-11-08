{ lib, buildPythonPackage, fetchPypi, fetchpatch, six
, wcwidth, pytest, mock, glibcLocales
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4db0f94e5761aea330b528e84a250027ffe996b5a94bf03e502600c9a5ad7a61";
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
