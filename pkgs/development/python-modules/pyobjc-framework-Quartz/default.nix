{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyobjc-framework-Cocoa";
  version = "11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${version}";
    hash = "sha256-2qPGJ/1hXf3k8AqVLr02fVIM9ziVG9NMrm3hN1de1Us=";
  };

  sourceRoot = "${src.name}/pyobjc-framework-Quartz";

  build-system = [ setuptools ];

  buildInputs = [
    darwin.libffi
  ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  # See https://github.com/ronaldoussoren/pyobjc/pull/641. Remove in next version:
  postPatch = ''
    substituteInPlace pyobjc_setup.py \
      --replace-fail "-buildversion" "-buildVersion" \
      --replace-fail "-productversion" "-productVersion" \
      --replace-fail "/usr/bin/sw_vers" "sw_vers" \
      --replace-fail "/usr/bin/xcrun" "xcrun"
  '';

  dependencies = [
    pyobjc-core
    pyobjc-framework-Cocoa
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [
    "Quartz"
    "Quartz.CoreGraphics"
    "Quartz.CoreVideo"
    "Quartz.ImageIO"
    "Quartz.ImageKit"
    "Quartz.PDFKit"
    "Quartz.QuartzComposer"
    "Quartz.QuartzCore"
    "Quartz.QuartzFilters"
    "Quartz.QuickLookUI"
  ];

  meta = {
    description = ''Wrappers for the "Quartz" related frameworks on macOS'';
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ toyboot4e ];
  };
}
