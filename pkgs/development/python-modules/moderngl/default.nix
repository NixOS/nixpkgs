{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  libGL,
  libx11,
  setuptools,
  glcontext,
  pkgs,
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UpNqmMyy8uHW48sYUospGfaDHn4/kk54i1hzutzlEps=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    substituteInPlace _moderngl.py \
      --replace-fail '"libGL.so"' '"${libGL}/lib/libGL.so"' \
      --replace-fail '"libEGL.so"' '"${libGL}/lib/libEGL.so"'
  '';

  build-system = [ setuptools ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [
    libGL
    libx11
  ];

  dependencies = [ glcontext ];

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [ "moderngl" ];

  meta = {
    description = "High performance rendering for Python";
    homepage = "https://github.com/moderngl/moderngl";
    changelog = "https://github.com/moderngl/moderngl/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
    inherit (pkgs.mesa.meta) platforms;
  };
}
