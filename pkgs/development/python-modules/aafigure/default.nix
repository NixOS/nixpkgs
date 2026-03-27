{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aafigure";
  version = "0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SfLB/StXnB//usE4aiZws/b0dcx/9swE2LmEiIwtnh4=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Fix impurity. TODO: Do the font lookup using fontconfig instead of this
  # manual method. Until that is fixed, we get this whenever we run aafigure:
  #   WARNING: font not found, using PIL default font
  patchPhase = ''
    sed -i "s|/usr/share/fonts|/nonexisting-fonts-path|" aafigure/PILhelper.py
  '';

  meta = {
    description = "ASCII art to image converter";
    mainProgram = "aafigure";
    homepage = "https://launchpad.net/aafigure/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.unix;
  };
})
