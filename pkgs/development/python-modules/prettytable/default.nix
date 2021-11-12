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
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d465005573a5c058d4ca343449a5b28c21252b86afcdfa168cdc6a440f0b24c";
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
