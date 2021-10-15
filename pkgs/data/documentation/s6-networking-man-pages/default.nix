{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.0.0.2";
  sha256 = "1ix8qrivp9prw0m401d7s9vkxhw16a4sxfhrs7abf9qqhs2zkd1r";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
