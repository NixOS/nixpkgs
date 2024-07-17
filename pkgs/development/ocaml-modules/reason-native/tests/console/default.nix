{
  lib,
  buildDunePackage,
  reason,
  console,
}:

buildDunePackage rec {
  pname = "console-test";
  version = "1";

  src = ./.;

  duneVersion = "3";

  buildInputs = [
    reason
    console
  ];

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/console-test | grep -q "{\"Hello fellow Nixer!\"}" > /dev/null
  '';
}
