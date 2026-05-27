{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  cython,
  distutils,
  fetchFromGitHub,
  gcc,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "primer3";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HL/kFpz5xvFDKgef2+AI/qjs2jakl00qfPSABYMGyrI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "Cython~=3.1.0" "cython"
  '';

  build-system = [
    cython
    distutils
    setuptools
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ gcc ];

  nativeCheckInputs = [
    click
    pytestCheckHook
  ];

  # We are not sure why exactly this is need. It seems `pytestCheckHook`
  # doesn't find extension modules installed in $out/${python.sitePackages},
  # and the tests rely upon them. This was initially reported upstream at
  # https://github.com/libnano/primer3-py/issues/120 and we investigate this
  # downstream at: https://github.com/NixOS/nixpkgs/issues/255262.
  preCheck = ''
    python setup.py build_ext --inplace
  '';

  pythonImportsCheck = [ "primer3" ];

  meta = {
    description = "Oligo analysis and primer design";
    homepage = "https://github.com/libnano/primer3-py";
    changelog = "https://github.com/libnano/primer3-py/blob/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
