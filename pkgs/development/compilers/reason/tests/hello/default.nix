{ lib, buildDunePackage, reason }:

buildDunePackage rec {
  pname = "helloreason";
  version = "0.0.1";

  src = ./.;

  useDune2 = true;

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
