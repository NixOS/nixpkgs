{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.0.0.1";
  sha256 = "02xvyby23b2x30jxd4nw9c5629j4hdaxq9sph3qhajlhl53yiyf2";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
