{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "ed25519";
  version = "1.5";

  src = fetchFromGitHub {
     owner = "warner";
     repo = "python-ed25519";
     rev = "1.5";
     sha256 = "0c7sh54divx1sar2914yljy3hli6fjknxpfri0jw9j86jl3y2283";
  };

  meta = with lib; {
    description = "Ed25519 public-key signatures";
    homepage = "https://github.com/warner/python-ed25519";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
