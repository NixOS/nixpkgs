{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "ftw";
  version = "unstable-2023-11-15";
  git-version = "e5e2f56";
  softwareName = "FTW: For The Web!";
  gerbil-package = "drewc/ftw";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "drewc";
    repo = "ftw";
    rev = "e5e2f56e90bf072ddf9c2987ddfac45f048e8a04";
    sha256 = "04164190vv1fzfk014mgqqmy5cml5amh63df31q2yc2kzvfajfc3";
  };

  meta = with lib; {
    description = "Simple web handlers for Gerbil Scheme";
    homepage    = "https://github.com/drewc/ftw";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
