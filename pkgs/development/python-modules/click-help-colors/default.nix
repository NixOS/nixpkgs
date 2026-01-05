{
  lib,
  fetchPypi,
  buildPythonPackage,
  click,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9Mq+Us9VApm4iI9PLuTF81msJ+M7z+TWHbR3haXMk2w=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_help_colors" ];

  meta = with lib; {
    description = "Colorization of help messages in Click";
    homepage = "https://github.com/click-contrib/click-help-colors";
    changelog = "https://github.com/click-contrib/click-help-colors/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
