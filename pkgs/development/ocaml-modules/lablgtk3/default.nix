{ lib, fetchFromGitHub, pkgconfig, buildDunePackage, gtk3, cairo2 }:

buildDunePackage rec {
  version = "3.0.beta5";
  pname = "lablgtk3";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgtk";
    rev = version;
    sha256 = "05n3pjy4496gbgxwbypfm2462njv6dgmvkcv26az53ianpwa4vzz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 ];
  propagatedBuildInputs = [ cairo2 ];

  meta = {
    description = "OCaml interface to gtk+-3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
