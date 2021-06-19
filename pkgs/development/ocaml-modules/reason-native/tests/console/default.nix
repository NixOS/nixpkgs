{ lib, buildDunePackage, reason, reason-native-console }:

buildDunePackage rec {
  pname = "console-test";
  version = "1";

  src = ./.;

  useDune2 = true;

  buildInputs = [
    reason
    reason-native-console
  ];

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/console-test | grep -q "{\"Hello fellow Nixer!\"}" > /dev/null
  '';
}
