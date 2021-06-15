{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.10.0.3.1";
  sha256 = "0q9b6v7kbyjsh390s4bw80kjdp92kih609vlmnpl1qzyrr6kivsg";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  sections = [ 1 7 ];
  maintainers = [ lib.maintainers.sternenseemann ];
}
