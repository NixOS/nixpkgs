import ./generic.nix {
  version = "4.4.4";
  sha256 = "sha256-Q8bkuF/1uJfqttJJoObnnLX3BEduv+qxsvOrVhMvRjA=";
  extraPatches = [
    {
      name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
      hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
    }
    # The upstream patch isn’t for ffmpeg 4, but it will apply with a few tweaks.
    # Fixes a crash when built with clang 16 due to UB in ff_seek_frame_binary.
    {
      name = "utils-fix_crash_in_ff_seek_frame_binary.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/ab792634197e364ca1bb194f9abe36836e42f12d";
      hash = "sha256-UxZ4VneZpw+Q/UwkEUDNdb2nOx1QnMrZ40UagspNTxI=";
      postFetch = ''
        substituteInPlace "$out" \
          --replace libavformat/seek.c libavformat/utils.c \
          --replace 'const AVInputFormat *const ' 'const AVInputFormat *'
      '';
    }
  ];
}
