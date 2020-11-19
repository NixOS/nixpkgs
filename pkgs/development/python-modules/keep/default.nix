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
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce71d14110df197ab5afdbd26a14c0bd266b79671118ae1351835fa192e61d9b";
  };

  propagatedBuildInputs = [
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
