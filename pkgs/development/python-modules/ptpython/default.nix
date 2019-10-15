{ stdenv, buildPythonPackage, fetchPypi, prompt_toolkit, docopt , jedi, pygments, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "2.0.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m34jbwj3j3762mg1vynpgciqw4kqdzdqjvd62mwhbjkly7ddsgb";
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
