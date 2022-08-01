{ lib, buildDunePackage, functoria, cmdliner_1_1, fmt, alcotest }:

buildDunePackage {
  pname = "functoria-runtime";

  inherit (functoria) version useDune2 src;

  propagatedBuildInputs = [ cmdliner_1_1 fmt ];
  checkInputs = [ alcotest functoria];
  doCheck = true;

  meta = with lib; {
    inherit (functoria.meta) homepage license;
    description = "Runtime support library for functoria-generated code";
    maintainers = [ maintainers.sternenseemann ];
  };
}
