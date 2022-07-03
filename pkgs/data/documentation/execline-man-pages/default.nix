{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.3.0.2";
  sha256 = "0fzv5as81aqgl8llbz8c5bk5n56iyh4g70r54wmj71rh2d1pihk5";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
