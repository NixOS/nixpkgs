{ lib, mkCoqDerivation, coq, version ? null }:

with lib; (mkCoqDerivation {
  pname = "tlc";
  owner = "charguer";
  inherit version;
  displayVersion = { tlc = false; };
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.12" "8.13"; out = "20210316"; }
    { case = range "8.10" "8.12"; out = "20200328"; }
    { case = range "8.6"  "8.12"; out = "20181116"; }
  ] null;
  release."20210316".sha256 = "1hlavnx20lxpf2iydbbxqmim9p8wdwv4phzp9ypij93yivih0g4a";
  release."20200328".sha256 = "16vzild9gni8zhgb3qhmka47f8zagdh03k6nssif7drpim8233lx";
  release."20181116".sha256 = "032lrbkxqm9d3fhf6nv1kq2z0mqd3czv3ijlbsjwnfh12xck4vpl";

  meta = {
    homepage = "http://www.chargueraud.org/softs/tlc/";
    description = "A non-constructive library for Coq";
    license = licenses.free;
    maintainers = [ maintainers.vbgl ];
  };
}).overrideAttrs (x:
  if versionAtLeast x.version "20210316"
  then {}
  else {
    installFlags = [ "CONTRIB=$(out)/lib/coq/${coq.coq-version}/user-contrib" ];
  }
)
