{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "deluge-client";
  version = "1.9.0";

  src = fetchFromGitHub {
     owner = "JohnDoee";
     repo = "deluge-client";
     rev = "1.9.0";
     sha256 = "0kjx808w6crpak0ihs32zxg6lmy3g3bv5amsfcf98h23kqz4vk5m";
  };

  # it will try to connect to a running instance
  doCheck = false;

  meta = with lib; {
    description = "Lightweight pure-python rpc client for deluge";
    homepage = "https://github.com/JohnDoee/deluge-client";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
