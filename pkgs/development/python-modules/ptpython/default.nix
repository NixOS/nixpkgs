{ lib, buildPythonPackage, pythonOlder, fetchPypi
, appdirs
, black
, importlib-metadata
, isPy3k
, jedi
, prompt_toolkit
, pygments
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.17";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "911d25cca31a8e4f9b2ecd16dcdad793b8859e94fca1275f3485d8cdf20b13de";
  };

  propagatedBuildInputs = [
    appdirs
    black # yes, this is in install_requires
    jedi
    prompt_toolkit
    pygments
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # no tests to run
  doCheck = false;

  meta = with lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
