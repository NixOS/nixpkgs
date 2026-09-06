{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pybind11,
  psutil,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyexiv2";
  version = "2.16.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LeoHsiao1";
    repo = "pyexiv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FH5nbbh0vaErJzBl6L2HPh0SQXkQ558abTBml7nSLU8=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    pybind11
    pkgs.exiv2
  ];

  preBuild = ''
    ln -s ${lib.getLib pkgs.exiv2}/lib/libexiv2${stdenv.hostPlatform.extensions.sharedLibrary} pyexiv2/lib/libexiv2${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ];

  # Remove source to prevent it trying to import from it instead of the built package
  preCheck = ''
    shopt -s extglob
    rm -r pyexiv2/!(tests)
  '';

  disabledTests = [
    # Asserts a specific exiv2 version
    "test_version"
  ];

  pythonImportsCheck = [
    "pyexiv2"
  ];

  meta = {
    description = "Python library for reading and writing image metadata, including EXIF, IPTC, XMP, ICC Profile";
    homepage = "https://github.com/LeoHsiao1/pyexiv2";
    changelog = "https://github.com/LeoHsiao1/pyexiv2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ambossmann ];
  };
})
