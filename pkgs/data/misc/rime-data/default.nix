{ lib, stdenv, fetchFromGitHub, librime }:

stdenv.mkDerivation {
  pname = "rime-data";
  version = "0.38.20231116";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "plum";
    rev = "6f502ff6fa87789847fa18200415318e705bffa4";
    sha256 = "sha256-DNSLP0dzzgJ6XzwvxGPeRqRrRIUV/GwD2+8cz9bYAwA=";
  };

  buildInputs = [ librime ];

  buildFlags = [ "all" ];
  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = import ./fetchSchema.nix fetchFromGitHub;

  postPatch = ''
    # Disable git operations.
    sed -i /fetch_or_update_package$/d scripts/install-packages.sh
  '';

  meta = with lib; {
    description = "Schema data of Rime Input Method Engine";
    longDescription = ''
      Rime-data provides schema data for Rime Input Method Engine.
    '';
    homepage = "https://rime.im";
    license = with licenses; [
      # rime-array
      # rime-combo-pinyin
      # rime-double-pinyin
      # rime-middle-chinese
      # rime-scj
      # rime-soutzoe
      # rime-stenotype
      # rime-wugniu
      gpl3Only

      # plum
      # rime-bopomofo
      # rime-cangjie
      # rime-emoji
      # rime-essay
      # rime-ipa
      # rime-jyutping
      # rime-luna-pinyin
      # rime-prelude
      # rime-quick
      # rime-stroke
      # rime-terra-pinyin
      # rime-wubi
      lgpl3Only

      # rime-pinyin-simp
      asl20

      # rime-cantonese
      cc-by-40
    ];
    maintainers = with maintainers; [ pmy ];
  };
}
