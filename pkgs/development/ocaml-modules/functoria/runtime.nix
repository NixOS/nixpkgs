{ lib, buildDunePackage, functoria, cmdliner, fmt }:

buildDunePackage {
  pname = "functoria-runtime";

  inherit (functoria) version src;

  propagatedBuildInputs = [ cmdliner fmt ];

  meta = with lib; {
    inherit (functoria.meta) homepage license;
    description = "Runtime support library for functoria-generated code";
    maintainers = [ maintainers.sternenseemann ];
  };
}
