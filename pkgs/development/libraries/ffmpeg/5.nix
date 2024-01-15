import ./generic.nix {
  version = "5.1.3";
  hash = "sha256-twfJvANLQGO7TiyHPMPqApfHLFUlOGZTTIIGEnjyvuE=";
  extraPatches = [
    {
      name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
      hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
    }
    {
      name = "libsvtav1-1.5.0-compat-vbv_bufsize.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/1c6fd7d756afe0f8b7df14dbf7a95df275f8f5ee";
      hash = "sha256-v9Viyo12QfZpbcVqd1aHgLl/DgSkdE9F1kr6afTGPik=";
    }
    {
      name = "libsvtav1-1.5.0-compat-maximum_buffer_size_ms-conditional.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/96748ac54f998ba6fe22802799c16b4eba8d4ccc";
      hash = "sha256-Z5HSe7YpryYGHD3BYXejAhqR4EPnmfTGyccxNvU3AaU=";
    }
  ];
}
