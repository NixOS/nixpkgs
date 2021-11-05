{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.8.1.0.3";
  sha256 = "1n7c75lmyrjzzcbwjl6fxhfs4k29qlr66r1q35799h942cn4li7v";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
