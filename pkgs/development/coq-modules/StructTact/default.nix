{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "StructTact";
  owner = "uwplse";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.6" "8.16"; out = "20210328"; }
    { case = range "8.5" "8.13"; out = "20181102"; }
  ] null;
  release."20210328".rev =    "179bd5312e9d8b63fc3f4071c628cddfc496d741";
  release."20210328".sha256 = "sha256:1y5r1zm3hli10ah6lnj7n8hxad6rb6rgldd0g7m2fjibzvwqzhdg";
  release."20181102".rev =    "82a85b7ec07e71fa6b30cfc05f6a7bfb09ef2510";
  release."20181102".sha256 = "08zry20flgj7qq37xk32kzmg4fg6d4wi9m7pf9aph8fd3j2a0b5v";
  preConfigure = ''
    if [ -f ./configure ]; then
      patchShebangs ./configure
    fi
  '';
}
