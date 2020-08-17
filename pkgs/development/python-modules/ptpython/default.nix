{ stdenv, lib, buildPythonPackage, pythonOlder, fetchPypi, prompt_toolkit, appdirs, docopt, jedi
, pygments, importlib-metadata, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5094e7e4daa77453d3c33eb7b7ebbf1060be4446521865a94e698bc85ff15930";
  };

  propagatedBuildInputs = [ appdirs prompt_toolkit docopt jedi pygments ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # no tests to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
