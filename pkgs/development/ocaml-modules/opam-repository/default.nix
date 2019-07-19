{ stdenv, fetchFromGitHub, buildDunePackage, opam-format }:

buildDunePackage rec {
  pname = "opam-repository";
  inherit (opam-format) version src enable_checks;

  propagatedBuildInputs = [
    opam-format
  ];

  meta = {
    description = "This library includes repository and remote sources handling, including curl/wget, rsync, git, mercurial, darcs backends.";
    license = stdenv.lib.licenses.lgpl2;
  };
}
