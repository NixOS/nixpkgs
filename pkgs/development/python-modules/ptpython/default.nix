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
  version = "3.0.20";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eafd4ced27ca5dc370881d4358d1ab5041b32d88d31af8e3c24167fe4af64ed6";
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
    homepage = "https://github.com/prompt-toolkit/ptpython";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
