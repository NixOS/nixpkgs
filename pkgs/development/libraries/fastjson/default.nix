<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "fastjson";
  version = "1.2304.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "libfastjson";
    rev = "refs/tags/v${version}";
    hash = "sha256-WnM6lQjHz0n5BwWWZoDBavURokcaROXJW46RZen9vj4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];
=======
{ lib, stdenv, fetchFromGitHub, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "1.2304.0";
  pname = "fastjson";
  src = fetchFromGitHub {
    repo = "libfastjson";
    owner = "rsyslog";
    rev = "v${version}";
    sha256 = "sha256-WnM6lQjHz0n5BwWWZoDBavURokcaROXJW46RZen9vj4=";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool ];

  preConfigure = ''
    sh autogen.sh
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A fast json library for C";
    homepage = "https://github.com/rsyslog/libfastjson";
    license = licenses.mit;
    maintainers = with maintainers; [ nequissimus ];
    platforms = with platforms; unix;
  };
}
