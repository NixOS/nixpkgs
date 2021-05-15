{ lib, fetchurl }:

let
  version = "1.0";
in fetchurl rec {
  name = "curie-${version}";

  url = "https://github.com/NerdyPepper/curie/releases/download/v${version}/curie-v${version}.tar.gz";

  downloadToTemp = true;

  recursiveHash = true;

  sha256 = "sha256-twPAzsbTveYW0rQd7FYZz5AMZgvPbNmn5c7Nfzn7B0A=";

  postFetch = ''
    tar xzf $downloadedFile
    mkdir -p $out/share/fonts/misc
    install *.otb $out/share/fonts/misc
  '';

  meta = with lib; {
    description = "An upscaled version of scientifica";
    homepage = "https://github.com/NerdyPepper/curie";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
