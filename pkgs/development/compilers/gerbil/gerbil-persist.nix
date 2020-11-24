{ lib, fetchFromGitHub, gerbilPackages, ... }:
{
  pname = "gerbil-persist";
  version = "unstable-2023-03-02";
  git-version = "0.1.0-24-ge2305f5";
  softwareName = "Gerbil-persist";
  gerbil-package = "clan/persist";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-crypto gerbil-poo ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-persist";
    rev = "e2305f53571e55292179286ca2d88e046ec6638b";
    sha256 = "1vsi4rfzpqg4hhn53d2r26iw715vzwz0hiai9r34z4diwzqixfgn";
  };

  meta = with lib; {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
