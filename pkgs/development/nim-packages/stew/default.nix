{ lib, buildNimPackage, fetchFromGitHub, snappy }:

buildNimPackage rec {
  pname = "stew";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-${pname}";
    rev = "478cc6efdefaabadf0666a3351fb959b78009bcc";
    hash = "sha256-txlTF0zNV5kV4KfE744oB3aVLCfWS9BdoKxUmTQTTRY=";
  };
  doCheck = false;
  meta = with lib;
    src.meta // {
      description =
        "Backports, standard library candidates and small utilities that don't yet deserve their own repository";
      license = [ lib.licenses.asl20 ];
      maintainers = [ maintainers.ehmry ];
    };
}
