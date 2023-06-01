{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, beautifulsoup4
, six
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.11.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AJskDgyfTI6vHQhWJdzUAR4S8PjOxV3t+epvdlXkm/4=";
  };

  propagatedBuildInputs = [ beautifulsoup4 six ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
