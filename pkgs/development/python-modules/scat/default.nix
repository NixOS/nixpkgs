{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
  python,
  pyusb,
  pyserial,
  bitstring,
  packaging,
  libscrc,
}:

buildPythonPackage (finalAttrs: {
  pname = "scat";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fgsect";
    repo = "scat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/O168L44AHGMOPbTFCTjFrgpcdTvabdXFnIMXK+2gyI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyusb
    pyserial
    bitstring
    packaging
    libscrc
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Signaling Collection and Analysis Tool";
    homepage = "https://github.com/fgsect/scat";
    changelog = "https://github.com/fgsect/scat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
