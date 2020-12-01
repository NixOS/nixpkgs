{ lib
, buildPythonPackage
, fetchPypi
, attrs
, nbformat
, nbdime
, nbclient
, sqlalchemy
, pythonOlder
, click-completion
, click-log
}:

buildPythonPackage rec {
  pname = "jupyter-cache";
  version = "0.4.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbcac451af61f94703d8630a10356b0d8a169c04c794045c8b0af11777b217fe";
  };

  propagatedBuildInputs = [
    attrs
    nbformat
    nbdime
    nbclient
    sqlalchemy
  ];

  checkInputs = [
    click-completion
    click-log
  ];

  meta = with lib; {
    description = "A defined interface for working with a cache of jupyter notebooks";
    homepage = https://github.com/ExecutableBookProject/jupyter-cache;
    license = licenses.mit;
  };
}