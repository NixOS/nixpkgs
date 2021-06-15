{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.0.1.1";
  sha256 = "0xv9v39na1qnd8cm4v7xb8wa4ap3djq20iws0lrqz7vn1w40i8b4";
  description = "Port of the documentation for the execline suite to mdoc";
  sections = [ 1 7 ];
  maintainers = [ lib.maintainers.sternenseemann ];
}
