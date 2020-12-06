{ stdenv, lib, buildPythonPackage, pythonOlder, fetchPypi, prompt_toolkit, appdirs, docopt, jedi
, pygments, importlib-metadata, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.7";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "34814eb410f854c823be4c4a34124e1dc8ca696da1c1fa611f9da606c5a8a609";
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
