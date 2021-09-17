{ lib, stdenv, fetchFromGitHub, librime }:

stdenv.mkDerivation {
  pname = "rime-data";
  version = "0.38.20210628";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "plum";
    rev = "0b835e347cad9c2d7038cfe82df5b5d1fe1c0327";
    sha256 = "0mja4wyazxdc6fr7pzij5ah4rzwxv4s12s64vfn5ikx1ias1f8ib";
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
    maintainers = [ maintainers.pengmeiyu ];
  };
}
