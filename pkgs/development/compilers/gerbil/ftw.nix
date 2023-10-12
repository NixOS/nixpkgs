{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "ftw";
  version = "unstable-2022-01-14";
  git-version = "8ba16b3";
  softwareName = "FTW: For The Web!";
  gerbil-package = "drewc/ftw";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "drewc";
    repo = "ftw";
    rev = "8ba16b3c1cdc2150df5af8ef3c92040ef8b563b9";
    sha256 = "153i6whm5jfcj9s1qpxz03sq67969lq11brssyjc3yv3wyb1b07h";
  };

  meta = with lib; {
    description = "Simple web handlers for Gerbil Scheme";
    homepage    = "https://github.com/drewc/ftw";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
