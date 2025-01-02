{
  lib,
  buildPythonPackage,
  fetchPypi,
  libGL,
  libX11,
  setuptools,
  glcontext,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UpNqmMyy8uHW48sYUospGfaDHn4/kk54i1hzutzlEps=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    libGL
    libX11
  ];

  dependencies = [ glcontext ];

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [ "moderngl" ];

  meta = with lib; {
    description = "High performance rendering for Python";
    homepage = "https://github.com/moderngl/moderngl";
    changelog = "https://github.com/moderngl/moderngl/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    # should be mesa.meta.platforms, darwin build breaks.
    platforms = platforms.linux;
  };
}
