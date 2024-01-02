{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-poo";
  version = "unstable-2023-10-07";
  git-version = "0.1-1-g367ab43";
  softwareName = "Gerbil-POO";
  gerbil-package = "clan/poo";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-poo";
    rev = "367ab4376fdd6fc0b0892da2becef35a5039c583";
    sha256 = "0ci88zqi7gb55ahl0n7dk1ihij2j6dn8jb6rzfiilck773x46kdh";
  };

  meta = with lib; {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
