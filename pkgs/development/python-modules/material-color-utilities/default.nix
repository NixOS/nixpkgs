{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  regex,
}:

buildPythonPackage rec {
  pname = "material-color-utilities-python";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PG8C585wWViFRHve83z3b9NijHyV+iGY2BdMJpyVH64=";
  };

  pythonRelaxDeps = [ "Pillow" ];

  propagatedBuildInputs = [
    pillow
    regex
  ];

  # No tests implemented.
  doCheck = false;

  pythonImportsCheck = [ "material_color_utilities_python" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/material_color_utilities_python";
    description = "Python port of material_color_utilities used for Material You colors";
    license = licenses.asl20;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
