{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.1.1.1";
  sha256 = "sha256-W1+f65+Su1ZjCtzstn/fqWyU9IlQMThd/1lOg1cbCaE=";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
