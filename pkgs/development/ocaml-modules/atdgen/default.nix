{
  buildDunePackage,
  alcotest,
  atd,
  atdgen-codec-runtime,
  atdgen-runtime,
  re,
  python3,
  biniou,
}:
let
  version = "2.15.0";
  atdgen-codec-runtime-2-15-0 = atdgen-codec-runtime.override {
    inherit version;
  };
  atdgen-runtime-2-15-0 = atdgen-runtime.override {
    inherit version;
  };
  atd-2-15-0 = atd.override {
    inherit version;
  };
in
# atdgen is deprecated since atd 2.16.0 was released
buildDunePackage {
  pname = "atdgen";
  inherit (atdgen-codec-runtime-2-15-0) version src;

  buildInputs = [
    atd-2-15-0
    re
  ];

  propagatedBuildInputs = [ atdgen-runtime-2-15-0 ];

  doCheck = true;
  nativeCheckInputs = [
    atd-2-15-0
    (python3.withPackages (ps: [ ps.jsonschema ]))
    biniou
  ];
  checkInputs = [
    alcotest
    atdgen-codec-runtime-2-15-0
  ];

  meta = (builtins.removeAttrs atd.meta [ "mainProgram" ]) // {
    description = "Generates efficient JSON serializers, deserializers and validators";
  };
}
