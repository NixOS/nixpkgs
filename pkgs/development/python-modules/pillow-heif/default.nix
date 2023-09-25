{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, pillow
, pytest
, nasm
, libheif
, libaom
, libde265
, x265
}:

buildPythonPackage rec {
  pname = "pillow_heif";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bigcat88";
    repo = "pillow_heif";
    rev = "refs/tags/v${version}";
    hash = "sha256-GbOW29rGpLMS7AfShuO6UCzcspdHtFS7hyNKori0otI=";
  };

  nativeBuildInputs = [ cmake nasm ];
  buildInputs = [ libheif libaom libde265 x265 ];
  propagatedBuildInputs = [ pillow ];
  nativeCheckInputs = [ pytest ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "pillow_heif" ];

  meta = {
    description = "Python library for working with HEIF images and plugin for Pillow";
    homepage = "https://github.com/bigcat88/pillow_heif";
    license = with lib.licenses; [ bsd3 lgpl3 ];
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
