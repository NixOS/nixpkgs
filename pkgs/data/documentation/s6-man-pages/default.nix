{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.0.0.1";
  sha256 = "00nxlpdf0kkdadyv84vj5w66y926pccqls8prkbip3zmcmnqgghs";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
