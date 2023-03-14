{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "nimSHA2";
  version = "unstable-2021-09-09";
  src = fetchFromGitHub {
    owner = "jangko";
    repo = pname;
    rev = "b8f666069dff1ed0c5142dd1ca692f0e71434716";
    hash = "sha256-Wqb3mQ7638UOTze71mf6WMyGiw9qTwhbJiGGb+9OR2k=";
  };
  doCheck = true;
  meta = src.meta // {
    description = "Secure Hash Algorithm 2";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
