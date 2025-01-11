{
  lib,
  buildDunePackage,
  reason,
}:

buildDunePackage rec {
  pname = "helloreason";
  version = "0.0.1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./helloreason.opam
      ./helloreason.re
      ./dune-project
      ./dune
    ];
  };

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    reason
  ];

  doCheck = true;

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/${pname} | grep -q "Hello From Reason" > /dev/null
  '';

  meta.timeout = 60;
}
