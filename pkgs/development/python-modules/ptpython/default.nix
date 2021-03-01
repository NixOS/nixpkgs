{ lib, buildPythonPackage, pythonOlder, fetchPypi
, appdirs
, black
, docopt
, importlib-metadata
, isPy3k
, jedi
, prompt_toolkit
, pygments
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.16";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b0f6e381a8251ec8d6aa94fe12f3400bf6edf789f89c8a6099f8a91d4a5d2e1";
  };

  propagatedBuildInputs = [
    appdirs
    black # yes, this is in install_requires
    docopt
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
