{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "tea";
  version = "0.10.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-JXF3oKbJ1G5UBfZYfEJcFw8H+J9KRn1aqSxUAyiRCIg=";
  };

  vendorHash = "sha256-1j8X4euJPbNeqEtYFKuRl9zARxUW0aWk07+AoNO24Qc=";

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
