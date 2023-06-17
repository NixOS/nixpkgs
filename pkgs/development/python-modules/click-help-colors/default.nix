{ lib, fetchPypi, buildPythonPackage
, click, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78cbcf30cfa81c5fc2a52f49220121e1a8190cd19197d9245997605d3405824d";
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
