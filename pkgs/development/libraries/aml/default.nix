{ stdenv, fetchFromGitHub, meson, pkg-config, ninja }:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pmiflkd9idnf6p0rnmccqqlj87k8crz9ixpx6rix671vnpk0xzi";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  meta = with stdenv.lib; {
    description = "Another main loop";
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
