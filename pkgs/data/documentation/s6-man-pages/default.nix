{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.0.1.1";
  sha256 = "03gl0vvdaqfb5hs0dfdbs9djxiyq3abcx9vwgkfw22b1rm2fa0r6";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
