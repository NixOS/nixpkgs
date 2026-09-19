{
  lib,
  python3Packages,
  fetchPypi,
  y4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xbstrap";
  version = "0.36";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-k+V+5VEP86Nd99MK9G5zo++B7IFZ2vho3mGCUhKr3GQ=";
  };

  postPatch = ''
    substituteInPlace xbstrap/base.py \
      --replace-fail 'y4_args = ["y4"]' 'y4_args = ["${lib.getBin y4}"]'
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    colorama
    jsonschema
    pyyaml
    zstandard
  ];

  __structuredAttrs = true;

  # has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/managarm/xbstrap/releases/tag/v${finalAttrs.version}";
    description = "Build system for OS distributions";
    homepage = "https://github.com/managarm/xbstrap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lzcunt
    ];
    mainProgram = "xbstrap";
  };
})
