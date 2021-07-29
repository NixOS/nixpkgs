{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "ftw";
  version = "unstable-2021-07-30";
  git-version = "a3686c6";
  softwareName = "FTW: For The Web!";
  gerbil-package = "drewc/smug";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "drewc";
    repo = "ftw";
    rev = "a3686c6909e9f1490ea0bab5d8b34f97932a8b6b";
    sha256 = "0b4ycrgv4kzsyd4ylad4xzrjfg4hnmbjbdjsr6dixdk3cj8mgxz7";
  };

  meta = with lib; {
    description = "Simple web handlers for Gerbil Scheme";
    homepage    = "https://github.com/drewc/ftw";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
