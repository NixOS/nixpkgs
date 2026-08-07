{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  packaging,
  pkgconfig,
  setuptools,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "faust-cchardet";
  version = "2.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "faust-streaming";
    repo = "cChardet";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-MeRX/g38c+q2jiTtEhUpaGYf+5tkhexRGuIG0PdUGvI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "packaging<26" packaging
  '';

  build-system = [
    cython
    packaging
    pkgconfig
    setuptools
  ];

  postFixup = ''
    # fake cchardet distinfo, so packages that depend on cchardet
    # accept it as a drop-in replacement
    ln -s $out/${python.sitePackages}/{faust_,}cchardet-${version}.dist-info
  '';

  pythonImportsCheck = [ "cchardet" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/faust-streaming/cChardet/blob/${src.tag}/CHANGES.rst";
    description = "High-speed universal character encoding detector";
    mainProgram = "cchardetect";
    homepage = "https://github.com/faust-streaming/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
  };
}
