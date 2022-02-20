{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, setuptools-scm
, wcwidth
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69fe75d78ac8651e16dd61265b9e19626df5d630ae294fc31687aa6037b97a58";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  # no test no longer available in pypi package
  doCheck = false;
  pythonImportsCheck = [ "prettytable" ];

  meta = with lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = "http://code.google.com/p/prettytable/";
    license = licenses.bsd3;
  };

}
