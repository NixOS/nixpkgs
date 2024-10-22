{ buildDunePackage, gluten, eio }:

buildDunePackage {
  pname = "gluten-eio";
  inherit (gluten) src version;

  propagatedBuildInputs = [ gluten eio ];

  meta = gluten.meta // {
    description = "EIO runtime for gluten";
  };
}
