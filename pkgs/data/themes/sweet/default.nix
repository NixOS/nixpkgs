{ lib, stdenv, fetchurl, unzip, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "sweet";
  version = "3.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Ambar-Blue.zip";
      sha256 = "sha256-6ZrjH5L7Yox7riR+2I7vVbFoG4k7xHGyOq1OnkllyiY";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Ambar.zip";
      sha256 = "sha256-FAbf682YJCCt8NKSdFoaFLwxLDU1aCcTgNdlybZtPMo=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Dark.zip";
      sha256 = "sha256-t6fczOnKwi4B9hSFhHQaQ533o7MFL+7HPtUJ/p2CIXM=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-mars.zip";
      sha256 = "sha256-QGkkpUqkxGPM1DXrvToB3taajk7vK3rqibQF2M4N9i0=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet.zip";
      sha256 = "sha256-1qVC2n7ypN1BFuSzBpbY7QzJUzF1anYNAVcMkNpGTMM";
    })
  ];

  nativeBuildInputs = [ unzip ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/
    cp -a Sweet* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Light and dark colorful Gtk3.20+ theme";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fuzen ];
    platforms = platforms.linux;
  };
}
