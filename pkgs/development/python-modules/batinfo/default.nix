{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "batinfo";
  version = "0.4.2";

  src = fetchFromGitHub {
     owner = "nicolargo";
     repo = "batinfo";
     rev = "v0.4.2";
     sha256 = "1wzkn2n7qkrzksz6hd1qfx6cb4kb0dlwd9sg055h5k8v1wj0j00s";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nicolargo/batinfo";
    description = "A simple Python lib to retrieve battery information";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ koral ];
  };
}
