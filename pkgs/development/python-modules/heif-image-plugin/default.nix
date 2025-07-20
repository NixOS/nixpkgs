{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  piexif,
  pillow,
}:

buildPythonPackage rec {
  pname = "heif-image-plugin";
  version = "0.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uploadcare";
    repo = "heif-image-plugin";
    rev = "v${version}";
    hash = "sha256-SlnnlBscNelNH0XkOenq3nolyqzRMK10SzVii61Moi4=";
  };

  propagatedBuildInputs = [
    cffi
    piexif
    pillow
  ];

  meta = {
    description = "Simple HEIF/HEIC images plugin for Pillow base on pyhief library";
    homepage = "https://github.com/uploadcare/heif-image-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
