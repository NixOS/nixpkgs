{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

let
  pname = "zot";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "project-zot";
    repo = "zot";
    tag = "v${version}";
    hash = "sha256-Evf556J2j+qCI4OtFT40yi3fQiZ0ubOTcCL8vsGHKb8=";
  };

  vendorHash = "sha256-DRbq56mh58DRme8tgxglMtneosfgbM35Z2QH/z5fNhc=";

  tags = [
    "imagetrust"
    "lint"
    "mgmt"
    "profile"
    "scrub"
    "search"
    "sync"
    "userprefs"
    "events"
  ];

  zotCmds = (
    lib.attrsets.genAttrs
      [
        "zb"
        "zli"
        "zot"
        "zxp"
      ]
      (
        cmd:
        buildGoModule {
          inherit
            version
            src
            vendorHash
            ;

          pname = cmd;
          subPackages = [ "cmd/${cmd}" ];
          tags = tags ++ (lib.optionals (cmd != "zxp") [ "metrics" ]);
          doCheck = false;
        }
      )
  );

in
stdenv.mkDerivation {
  inherit pname;
  inherit version;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    cp ${zotCmds.zb}/bin/zb $out/bin/
    cp ${zotCmds.zli}/bin/zli $out/bin/
    cp ${zotCmds.zot}/bin/zot $out/bin/
    cp ${zotCmds.zxp}/bin/zxp $out/bin/
  '';

  meta = with lib; {
    description = "A production-ready vendor-neutral OCI image registry";
    homepage = "https://zotregistry.dev";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
