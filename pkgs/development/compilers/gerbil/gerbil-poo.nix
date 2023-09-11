{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-poo";
  version = "unstable-2023-04-28";
  git-version = "0.0-106-g418b582";
  softwareName = "Gerbil-POO";
  gerbil-package = "clan/poo";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-poo";
    rev = "418b582ae72e1494cf3a5f334d31d4f6503578f5";
    sha256 = "0qdzs7l6hp45dji5bc3879k4c8k9x6cj4qxz68cskjhn8wrc5lr8";
  };

  meta = with lib; {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
