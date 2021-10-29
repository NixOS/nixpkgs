{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.0.0.2";
  sha256 = "1ddab4l4wwrg2jdcrdqp1rx8dzbzbdsvx4mzayraxva4q97d1g9r";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
