{ stdenv, buildPythonPackage, fetchPypi, prompt_toolkit, appdirs, docopt, jedi
, pygments, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "556e5367d4d58231b575dc619493dc0d8ef4c2d15ee85c727a88beb60fa5c52b";
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
