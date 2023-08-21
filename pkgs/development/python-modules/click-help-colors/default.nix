{ lib, fetchPypi, buildPythonPackage
, click, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dWJF5ULSkia7O8BWv6WIhvISuiuC9OjPX8iEF2rJbXI=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_help_colors" ];

  meta = with lib; {
    description = "Colorization of help messages in Click";
    homepage    = "https://github.com/r-m-n/click-help-colors";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
