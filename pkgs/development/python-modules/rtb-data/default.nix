{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "rtb-data";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "rtb_data";
    inherit (finalAttrs) version;
    hash = "sha256-RNdaiszJjnAxIe1Hi13zYE9G0JyinipwQy0pO6zSd2w=";
  };

  build-system = [ hatchling ];

  # Tests are shipped with PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "rtbdata" ];

  meta = {
    description = "Data files for the Robotics Toolbox for Python";
    homepage = "https://github.com/petercorke/robotics-toolbox-python";
    changelog = "https://github.com/petercorke/robotics-toolbox-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
})
