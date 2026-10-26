{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  libuchardet,
  meson-python,
  pkg-config,
  pytestCheckHook,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "faust-cchardet";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "faust-streaming";
    repo = "cChardet";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jXMf553NsgXgjuvEMKEst8s8k6nE5868DvUPV3Udvvk=";
  };

  build-system = [
    cython
    meson-python
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  mesonFlags = [
    "-Dsystem-uchardet=auto"
  ];

  buildInputs = [
    libuchardet
  ];

  postFixup = ''
    # fake cchardet distinfo, so packages that depend on cchardet
    # accept it as a drop-in replacement
    ln -s $out/${python.sitePackages}/{faust_,}cchardet-${finalAttrs.version}.dist-info
  '';

  pythonImportsCheck = [ "cchardet" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/faust-streaming/cChardet/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "High-speed universal character encoding detector";
    mainProgram = "cchardetect";
    homepage = "https://github.com/faust-streaming/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
  };
})
