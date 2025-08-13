{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vk5kn8w3zf2ymi76l8cpwmvvavkmh3b9lb18xw3x1vzbmhz2f7d";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    lxml
    pyte
    wcwidth
  ];

  pythonImportsCheck = [ "termtosvg" ];

  meta = with lib; {
    homepage = "https://nbedos.github.io/termtosvg/";
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "termtosvg";
  };
}
