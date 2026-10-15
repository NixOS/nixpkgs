{
  buildDunePackage,
  fetchFromGitHub,
  lib,
}:

buildDunePackage rec {
  pname = "ubase";
  version = "0.20";

  minimalOCamlVersion = "4.14.0";

  src = fetchFromGitHub {
    owner = "sanette";
    repo = "ubase";
    tag = version;
    sha256 = "sha256-zmYjWEk0r1h87RczCJu2tYlS79F/pAiBt16BplPmA7c=";
  };

  doCheck = true;

  meta = {
    description = "Remove accents from utf8 strings";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/sanette/ubase";
    maintainers = with lib.maintainers; [ mrdev023 ];
  };
}
