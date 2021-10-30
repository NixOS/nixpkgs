{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.1.0.2";
  sha256 = "1fl3pyjh9328l1h2b6s08j048jl4pfyyc24mjs45qx545kcp65q4";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
