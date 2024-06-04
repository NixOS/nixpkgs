{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  libavif,
  setuptools,
  wheel,
  pillow,
}:
buildPythonPackage rec {
  pname = "pillow-avif-plugin";
  version = "1.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o3e+lNWzgQ4H4CIYBkkOjhoojzjnIiVn2BCl2haxu80=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    libavif
    pillow
  ];

  pythonImportsCheck = [ "pillow_avif" ];

  meta = with lib; {
    description = "Pillow plugin that adds avif support via libavif";
    homepage = "https://github.com/fdintino/pillow-avif-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
