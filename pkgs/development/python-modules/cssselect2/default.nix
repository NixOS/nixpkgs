{ lib, buildPythonPackage, fetchPypi, tinycss2, pytestrunner, pytestcov, pytest-flake8, pytest-isort, glibcLocales }:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "505d2ce3d3a1d390ddb52f7d0864b7efeb115a5b852a91861b498b92424503ab";
  };

  propagatedBuildInputs = [ tinycss2 ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = https://github.com/Kozea/cssselect2;
    license = licenses.bsd3;
  };
}
