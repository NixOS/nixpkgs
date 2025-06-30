{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.19.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hap5uTJ5+IfRwjXlzFx54yZEVkE4zkaYmrD0ovyXDXw=";
  };

  patches = [
    # Removed depreciated imp and replaced with importlib, https://github.com/Knio/pynmea2/pull/164
    (fetchpatch {
      name = "remove-imp.patch";
      url = "https://github.com/Knio/pynmea2/commit/c56717b5e859e978ad3b52b8f826faa5d50489f8.patch";
      hash = "sha256-jeFyfukT+0NLNxvNCxL7TzL/8oKmKOam5ZUIvjdvN/Q=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynmea2" ];

  meta = {
    description = "Python library for the NMEA 0183 protcol";
    homepage = "https://github.com/Knio/pynmea2";
    changelog = "https://github.com/Knio/pynmea2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
