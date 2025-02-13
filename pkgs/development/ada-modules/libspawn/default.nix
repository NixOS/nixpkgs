{
  fetchFromGitHub,
  gnat,
  gprbuild,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libspawn";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "spawn";
    rev = "v${version}";
    sha256 = "sha256-XD5orxMGXFBVvc9UjSLXGb0yP5tDGNubykQ1b0B9o/k=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "all"
  ];

  meta = with lib; {
    description = "This library provides simple API to spawn processes and communicate with them.";
    homepage = "https://github.com/AdaCore/spawn";
    maintainers = with maintainers; [ felixsinger ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
