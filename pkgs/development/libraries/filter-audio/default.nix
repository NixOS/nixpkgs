{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "filter-audio-20150624";

  src = fetchgit {
    url = "https://github.com/irungentoo/filter_audio.git";
    rev = "612c5a102550c614e4c8f859e753ea64c0b7250c";
    sha256 = "0bmf8dxnr4vb6y36lvlwqd5x68r4cbsd625kbw3pypm5yqp0n5na";
  };

  doCheck = false;

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight audio filtering library made from webrtc code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}


