{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, setuptools_scm
, wcwidth
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5882ed9092b391bb8f6e91f59bcdbd748924ff556bb7c634089d5519be87baa0";
  };

  nativeBuildInputs = [ setuptools_scm ];
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [ wcwidth ];

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
