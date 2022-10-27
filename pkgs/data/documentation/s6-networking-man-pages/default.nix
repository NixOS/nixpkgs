{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.1.1.1";
  sha256 = "sha256-RGXOSCsl1zfiXf5pIgsex/6LWtKh7ne0R7rqHvnQB8E=";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
