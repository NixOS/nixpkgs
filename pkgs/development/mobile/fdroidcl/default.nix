{ lib
, buildGoModule
, fetchFromGitHub
, android-tools
}:

buildGoModule rec {
  pname = "fdroidcl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "fdroidcl";
    rev = "v${version}";
    hash = "sha256-tqhs3b/DHfnGOm9qcM56NSzt1GJflJfbemkp7+nXbug=";
  };

  patches = [ ./go_mod_version_update.patch ];

  vendorHash = "sha256-BWbwhHjfmMjiRurrZfW/YgIzJUH/hn+7qonD0BcTLxs=";

  postPatch = ''
    substituteInPlace adb/{server,device}.go \
      --replace 'exec.Command("adb"' 'exec.Command("${android-tools}/bin/adb"'
  '';

  # TestScript/search attempts to connect to fdroid
  doCheck = false;

  meta = with lib; {
    description = "F-Droid command line interface written in Go";
    mainProgram = "fdroidcl";
    homepage = "https://github.com/mvdan/fdroidcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aleksana ];
  };
}
