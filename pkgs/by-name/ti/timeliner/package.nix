{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "timeliner";
  version = "0-unstable-2024-08-05";
  vendorHash = "sha256-m/VyKp0mTLAhjLJIhKBYGauavzk09SYlO94SwuQ2icw=";

  src = fetchFromGitHub {
    owner = "airbus-cert";
    repo = "timeliner";
    rev = "a41292eec4bb99e5c253343b4e426dee1858906c";
    hash = "sha256-KwYguwCNSE1elKbyiWFf6nuRs67GVAxEMAPsQJSU1PE=";
  };

  postInstall = ''
    mv $out/bin/main $out/bin/timeliner
  '';

  meta = {
    description = "Rewrite of mactime, a bodyfile reader";
    homepage = "https://github.com/airbus-cert/timeliner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "timeliner";
  };
}
