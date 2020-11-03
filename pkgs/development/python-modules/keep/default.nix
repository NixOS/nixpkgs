{ stdenv
, buildPythonPackage
, fetchPypi
, PyGithub
, terminaltables
, click
, requests
}:

buildPythonPackage rec {
  pname = "keep";
  version = "2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0902kcvhbmy5q5n0ai1df29ybf87qaljz306c5ssl8j9xdjipcq2";
  };

  requiredPythonModules = [
    click
    requests
    terminaltables
    PyGithub
  ];

  # no tests
  pythonImportsCheck = [ "keep" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/orkohunter/keep";
    description = "A Meta CLI toolkit: Personal shell command keeper and snippets manager";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
