{ buildDunePackage, trace, mtime }:

buildDunePackage {
  pname = "trace-tef";
  inherit (trace) src version;

  # This removes the dependency on the “atomic” package
  # (not available in nixpkgs)
  # Said package for OCaml ≥ 4.12 is empty
  postPatch = ''
    substituteInPlace src/tef/dune --replace 'atomic ' ""
  '';

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [ mtime trace ];

  doCheck = true;

  meta = trace.meta // {
    description = "A simple backend for trace, emitting Catapult JSON into a file";
  };

}
