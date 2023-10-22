{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cmake
, nasm

# native dependencies
, libheif
, libaom
, libde265
, x265

# dependencies
, pillow

# tests
, opencv4
, numpy
, pympler
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pillow-heif";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bigcat88";
    repo = "pillow_heif";
    rev = "refs/tags/v${version}";
    hash = "sha256-GbOW29rGpLMS7AfShuO6UCzcspdHtFS7hyNKori0otI=";
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libaom
    libde265
    libheif
    x265
  ];

  propagatedBuildInputs = [
    pillow
  ];

  pythonImportsCheck = [
    "pillow_heif"
  ];

  nativeCheckInputs = [
    opencv4
    numpy
    pympler
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/bigcat88/pillow_heif/releases/tag/v${version}";
    description = "Python library for working with HEIF images and plugin for Pillow";
    homepage = "https://github.com/bigcat88/pillow_heif";
    license = with lib.licenses; [ bsd3 lgpl3 ];
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
