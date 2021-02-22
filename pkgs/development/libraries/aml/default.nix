{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja }:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mxmzlhiv88hm4sf8kyawyrml8qy1xis019hdyb5skl9g95z9yyf";
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
