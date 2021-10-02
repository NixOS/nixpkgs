{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.4.1.1.1";
  sha256 = "1qrqzm2r4rxf8hglz8k4laknjqcx1y0z1kjf636z91w1077qg0pn";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  sections = [ 1 7 ];
  maintainers = [ lib.maintainers.sternenseemann ];
}
