{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, beautifulsoup4
, six
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-crOkiv/M8v7rJd/Tvsq67PU76vTgi+aNzthEcniDKBM=";
  };

  propagatedBuildInputs = [ beautifulsoup4 six ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
