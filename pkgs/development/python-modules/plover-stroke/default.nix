{
  lib,
  fetchPypi,
  python3Packages,
  setuptools,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-stroke";
  version = "1.1.0";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Helper class for working with steno strokes";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_stroke";
    inherit version;
    hash = "sha256-3gOyP0ruZrZfaffU7MQjNoG0NUFQLYa/FP3inqpy0VM=";
  };
}
