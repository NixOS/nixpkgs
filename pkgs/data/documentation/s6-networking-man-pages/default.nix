{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.1.0.1";
  sha256 = "1h87s3wixsms8ys7gvm1s9d8pzn73q5j4sgybpi3gmr55d4cwra4";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
