import ./generic.nix {
  version = "4.4.4";
  sha256 = "sha256-Q8bkuF/1uJfqttJJoObnnLX3BEduv+qxsvOrVhMvRjA=";
  extraPatches = [
    {
      name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
      hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
    }
  ];
}
