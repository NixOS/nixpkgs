{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "tea";
  version = "0.10.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-Dhb3y13sxkyE+2BjNj7YcsjiIPgznIVyuzWs0F8LNfU=";
  };

  vendorHash = "sha256-mKCsBPBWs3+61em53cEB0shTLXgUg4TivJRogy1tYXw=";

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage = "https://gitea.com/gitea/tea";
    license = licenses.mit;
    maintainers = with maintainers; [
      j4m3s
      techknowlogick
    ];
    mainProgram = "tea";
  };
}
