{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.1.0.1";
  sha256 = "0d3lzxy7wv91q3nr6bw1wfmrfj285i15wmj4c8v9k9pxjg42iwwx";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
