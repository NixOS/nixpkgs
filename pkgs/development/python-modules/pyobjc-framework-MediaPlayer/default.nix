{
  buildPythonPackage,
  setuptools,
  darwin,
  pyobjc-core,
  pyobjc-framework-AVFoundation,
  lib,
}:

buildPythonPackage rec {
  pname = "pyobjc-framework-MediaPlayer";
  pyproject = true;

  inherit (pyobjc-core) version src;

  sourceRoot = "${src.name}/pyobjc-framework-MediaPlayer";

  build-system = [ setuptools ];

  buildInputs = [ darwin.libffi ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
  # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
  postPatch = ''
    substituteInPlace pyobjc_setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion" \
      --replace-fail "/usr/bin/sw_vers" "sw_vers" \
      --replace-fail "/usr/bin/xcrun" "xcrun"
  '';

  dependencies = [
    pyobjc-core
    pyobjc-framework-AVFoundation
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [
    "MediaPlayer"
  ];

  meta = {
    description = "PyObjC wrappers for the MediaPlayer framework on macOS";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-framework-MediaPlayer";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
