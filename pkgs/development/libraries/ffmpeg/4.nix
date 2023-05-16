import ./generic.nix rec {
<<<<<<< HEAD
  version = "4.4.4";
  sha256 = "sha256-Q8bkuF/1uJfqttJJoObnnLX3BEduv+qxsvOrVhMvRjA=";
  extraPatches = [
    {
      name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
      hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
    }
  ];
=======
  version = "4.4.3";
  sha256 = "sha256-zZDzG1hD+0AHqElzeGR6OVm+H5wqtdktloSPmEUzT/c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
