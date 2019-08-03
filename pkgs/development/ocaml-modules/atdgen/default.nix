{ buildDunePackage, atd, biniou, yojson }:

let runtime =
  buildDunePackage {
    pname = "atdgen-runtime";
    inherit (atd) version src;

    propagatedBuildInputs = [ biniou yojson ];

    meta = { inherit (atd.meta) license; };
  }
; in

buildDunePackage {
  pname = "atdgen";
  inherit (atd) version src;

  buildInputs = [ atd ];

  propagatedBuildInputs = [ runtime ];

  meta = {
    description = "Generates efficient JSON serializers, deserializers and validators";
    inherit (atd.meta) license;
  };
}
