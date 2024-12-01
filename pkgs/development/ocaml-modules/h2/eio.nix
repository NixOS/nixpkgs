{ buildDunePackage
, h2
, eio
, gluten-eio
}:

buildDunePackage {
  pname = "h2-eio";

  inherit (h2) src version;

  propagatedBuildInputs = [ eio gluten-eio h2 ];

  meta = h2.meta // {
    description = "EIO support for h2";
  };
}

