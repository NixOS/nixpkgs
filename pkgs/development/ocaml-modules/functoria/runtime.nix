{ lib, buildDunePackage, functoria, cmdliner_1_1, fmt }:

buildDunePackage {
  pname = "functoria-runtime";

  inherit (functoria) version src;

  propagatedBuildInputs = [ cmdliner_1_1 fmt ];

  meta = with lib; {
    inherit (functoria.meta) homepage license;
    description = "Runtime support library for functoria-generated code";
    maintainers = [ maintainers.sternenseemann ];
  };
}
