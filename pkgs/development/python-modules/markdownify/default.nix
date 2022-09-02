{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, beautifulsoup4
, six
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.11.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uPmakJ92tBqt+3SPLD6+I39B37JhdEZFr2cSwe0r11g=";
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
