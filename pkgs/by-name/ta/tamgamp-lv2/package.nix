{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  lv2,
  zita-resampler,
}:

stdenv.mkDerivation rec {
  pname = "tamgamp.lv2";
  version = "unstable-2020-06-14";

  src = fetchFromGitHub {
    owner = "sadko4u";
    repo = "tamgamp.lv2";
    rev = "426da74142fcb6b7687a35b2b1dda3392e171b92";
    sha256 = "0dqsnim7v79rx13bkkh143gqz0xg26cpf6ya3mrwwprpf5hns2bp";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lv2
    zita-resampler
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/sadko4u/tamgamp.lv2";
    description = "Guitar amplifier simulator";
    longDescription = ''
      Tamgamp (Pronouncement: "Damage Amp") is an LV2 guitar amp simulator that provides two plugins:

       - Tamgamp - a plugin based on Guitarix DK Builder simulated chains.
       - TamgampGX - a plugin based on tuned Guitarix internal amplifiers implementation.

      The reference to the original Guitarix project: https://guitarix.org/

      It simulates the set of the following guitar amplifiers:

      - Fender Princeton Reverb-amp AA1164 (without reverb module)
      - Fender Twin Reverb-Amp AA769 (Normal channel, bright off)
      - Fender Twin Reverb-Amp AA769 (Vibrato channel, bright on)
      - Marshall JCM-800 High-gain input
      - Marshall JCM-800 Low-gain input
      - Mesa/Boogie DC3 preamplifier (lead channel)
      - Mesa/Boogie DC3 preamplifier (rhythm channel)
      - Mesa Dual Rectifier preamplifier (orange channel, less gain)
      - Mesa Dual Rectifier preamplifier (red channel, more gain)
      - Peavey 5150II crunch channel
      - Peavey 5150II lead channel
      - VOX AC-30 Brilliant channel
      - VOX AC-30 normal channel
    '';
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
