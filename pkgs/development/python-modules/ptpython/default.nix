{ stdenv, buildPythonPackage, fetchPypi, prompt_toolkit, docopt , jedi, pygments, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "2.0.6";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "90e24040e82de4abae0bbe6e352d59ae6657e14e1154e742c0038679361b052f";
  };

  propagatedBuildInputs = [ prompt_toolkit docopt jedi pygments ];

  # no tests to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
