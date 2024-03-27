{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, beautifulsoup4
, six
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.12.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H7CMYYsw4O56MaObmY9EoY+yirJU9V9K8GttNaIXnic=";
  };

  propagatedBuildInputs = [ beautifulsoup4 six ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "HTML to Markdown converter";
    mainProgram = "markdownify";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
