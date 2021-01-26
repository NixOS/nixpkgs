{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, setuptools_scm
, wcwidth
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e37acd91976fe6119172771520e58d1742c8479703489321dc1d9c85e7259922";
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
