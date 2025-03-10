{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # dependencies
  blessed,
  prefixed,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qfpY4o5i3+9wg5D+6w7jxOZHgsACdGqUhzOQ/sF3/v4=";
  };

  dependencies = [
    blessed
    prefixed
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "enlighten" ];

  meta = {
    description = "Enlighten Progress Bar for Python Console Apps";
    homepage = "https://github.com/Rockhopper-Technologies/enlighten";
    changelog = "https://github.com/Rockhopper-Technologies/enlighten/releases/tag/${version}";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [
      veprbl
      doronbehar
    ];
  };
}
