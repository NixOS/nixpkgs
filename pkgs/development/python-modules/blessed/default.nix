{ stdenv, buildPythonPackage, fetchPypi, six, wcwidth, pytest, mock
, glibcLocales }:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "777b0b6b5ce51f3832e498c22bc6a093b6b5f99148c7cbf866d26e2dec51ef21";
  };

  checkInputs = [ pytest mock glibcLocales ];

  checkPhase = ''
    LANG=en_US.utf-8 py.test blessed/tests
  '';

  propagatedBuildInputs = [ wcwidth six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jquast/blessed;
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
