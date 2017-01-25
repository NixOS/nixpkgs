{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation {
  name = "pony-stable-2016-10-10";

  src = fetchFromGitHub {
    owner = "jemc";
    repo = "pony-stable";
    rev = "fdefa26fed93f4ff81c323f29abd47813c515703";
    sha256 = "16inavy697icgryyvn9gcylgh639xxs7lnbrqdzcryvh0ck15qxk";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.dipinhora ];
    platforms = stdenv.lib.platforms.unix;
  };
}
