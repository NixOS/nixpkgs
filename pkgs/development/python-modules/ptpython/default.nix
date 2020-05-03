{ stdenv, buildPythonPackage, fetchPypi, prompt_toolkit, appdirs, docopt, jedi
, pygments, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a69cce0aa04f0075e2e65287a0ee2f3a928c0591b301ce22aa2e498af1ebcb4b";
  };

  propagatedBuildInputs = [ appdirs prompt_toolkit docopt jedi pygments ];

  # no tests to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
