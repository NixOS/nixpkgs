{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "intel-one-mono";
  version = "1.0.0";

  # v1.0.0 tag actually doesn't have any files, so using release archives
  srcs = [
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${version}/otf.zip";
      sha256 = "sha256-RxvLuWZiX4ojjw1jjLyWIqwW1RMGShJBlnmPYrxMgaw=";
    })
    (fetchurl {
      url = "https://github.com/intel/intel-one-mono/releases/download/V${version}/ttf.zip";
      sha256 = "sha256-skcETQOniKCHhfaj9RKOHxvDKmC93Aj9cudLG7K83bE=";
    })
  ];


  nativeBuildInputs = [
    unzip
  ];

  unpackCmd = ''
    for src in $srcs; do
      unzip -o $src -d src
    done
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ ttf/*.ttf
    install -Dm644 -t $out/share/fonts/opentype/ otf/*.otf
    runHook postInstall
  '';


  meta = with lib; {
    description = "Intel One Mono Typeface";
    homepage = "https://github.com/intel/intel-one-mono";
    changelog = "https://github.com/intel/intel-one-mono/releases/tag/V${version}";
    license = licenses.ofl;
    maintainers = [ maintainers.dpc ];
    platforms = platforms.all;
  };
}
