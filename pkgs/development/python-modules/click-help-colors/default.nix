<<<<<<< HEAD
{ lib
, fetchPypi
, buildPythonPackage
, click
, pytestCheckHook
, pythonOlder
=======
{ lib, fetchPypi, buildPythonPackage
, click, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "click-help-colors";
<<<<<<< HEAD
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dWJF5ULSkia7O8BWv6WIhvISuiuC9OjPX8iEF2rJbXI=";
  };

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "click_help_colors"
  ];

  meta = with lib; {
    description = "Colorization of help messages in Click";
    homepage = "https://github.com/click-contrib/click-help-colors";
    changelog = "https://github.com/click-contrib/click-help-colors/blob/${version}/CHANGES.rst";
    license = licenses.mit;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ freezeboy ];
  };
}
