{ lib, fetchFromGitHub, gerbilPackages, ... }:
{
  pname = "gerbil-persist";
  version = "unstable-2023-10-07";
  git-version = "0.1.1-1-g3ce1d4a";
  softwareName = "Gerbil-persist";
  gerbil-package = "clan/persist";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-crypto gerbil-poo gerbil-leveldb ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-persist";
    rev = "3ce1d4a4b1d7be290e54f884d780c02ceee8f10e";
    sha256 = "1kzvgpqkpq4wlc0hlfxy314fbv6215aksrrlrrpq9w97wdibmv7x";
  };

  meta = with lib; {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
