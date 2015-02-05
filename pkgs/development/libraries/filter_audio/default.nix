{ stdenv, fetchFromGitHub, utillinux }:

stdenv.mkDerivation rec {
  name = "filter_audio-${version}";
  version = "76428a6cda43ae77f3936f4527c5f86eb3a5e211";

  src = fetchFromGitHub {
    owner  = "irungentoo";
    repo   = "filter_audio";
    rev    = "${version}";
    sha256 = "0c4wp9a7dzbj9ykfkbsxrkkyy0nz7vyr5map3z7q8bmv9pjylbk9";
  };

  buildInputs = [ utillinux ];
  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "An easy to use audio filtering library made from webrtc code";
    homepage    = https://github.com/irungentoo/filter_audio;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ np ];
    platforms   = platforms.unix;
  };
}
