{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja }:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m911n3rd41ch4yk3k9k1lz29xp3h54k6jx122abq5kmngy9znqw";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  meta = with lib; {
    description = "Another main loop";
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
    broken = stdenv.isDarwin;
  };
}
