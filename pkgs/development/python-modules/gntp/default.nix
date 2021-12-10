{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "gntp";
  version = "1.0.3";

  src = fetchFromGitHub {
     owner = "kfdm";
     repo = "gntp";
     rev = "v1.0.3";
     sha256 = "082qm9gz7qxm6zi543yr9vhfgny2fq9rf2sbj2kr1wshw3kzqcrc";
  };

  pythonImportsCheck = [ "gntp" "gntp.notifier" ];

  # requires a growler service to be running
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kfdm/gntp/";
    description = "Python library for working with the Growl Notification Transport Protocol";
    license = licenses.mit;
    maintainers = [ maintainers.jfroche ];
  };
}
