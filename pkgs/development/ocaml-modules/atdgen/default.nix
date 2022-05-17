{ buildDunePackage, alcotest, atd, atdgen-codec-runtime, atdgen-runtime, biniou, re, yojson }:

buildDunePackage {
  pname = "atdgen";
  inherit (atdgen-codec-runtime) version src;

  buildInputs = [ atd re ];

  propagatedBuildInputs = [ atdgen-runtime ];

  doCheck = true;
  checkInputs = [ alcotest atdgen-codec-runtime ];

  meta = (builtins.removeAttrs atd.meta [ "mainProgram" ]) // {
    description = "Generates efficient JSON serializers, deserializers and validators";
  };
}
