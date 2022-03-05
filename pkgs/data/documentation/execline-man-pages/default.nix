{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.1.0.4";
  sha256 = "1cxi09dlzvjbilmzgmr3xvwvx0l3s1874k3gr85kbjnvp1c1r6cd";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
