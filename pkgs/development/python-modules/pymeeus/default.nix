{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "pymeeus";
  version = "0.5.12";
  pyproject = true;

  src = fetchPypi {
    pname = "PyMeeus";
    inherit version;
    hash = "sha256-VI9xhr2LlsvAac9kmo6ON33OSax0SGcJhJ/mOpnK1oQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest7CheckHook ];

  meta = with lib; {
    homepage = "https://github.com/architest/pymeeus";
    description = "Library of astronomical algorithms";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
