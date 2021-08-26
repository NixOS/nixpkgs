{ lib, buildPythonPackage, pythonOlder, fetchPypi
, appdirs
, black
, importlib-metadata
, isPy3k
, jedi
, prompt-toolkit
, pygments
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.19";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3d41ce7c2ce0e7e55051347eae400fc56b9b42b1c4a9db25b19ccf6195bfc12";
  };

  propagatedBuildInputs = [
    appdirs
    black # yes, this is in install_requires
    jedi
    prompt-toolkit
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
