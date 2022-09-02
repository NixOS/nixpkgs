{ buildDunePackage, alcotest, atd, atdgen-codec-runtime, atdgen-runtime, biniou, re, yojson
, python3
}:

buildDunePackage {
  pname = "atdgen";
  inherit (atdgen-codec-runtime) version src;

  buildInputs = [ atd re ];

  propagatedBuildInputs = [ atdgen-runtime ];

  doCheck = true;
  checkInputs = [ alcotest atdgen-codec-runtime
    (python3.withPackages (ps: [ ps.jsonschema ]))
  ];

  meta = (builtins.removeAttrs atd.meta [ "mainProgram" ]) // {
    description = "Generates efficient JSON serializers, deserializers and validators";
  };
}
