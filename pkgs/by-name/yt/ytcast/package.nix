{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ytcast";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "MarcoLucidi01";
    repo = "ytcast";
    rev = "v${version}";
    sha256 = "sha256-iy9+MgXwP4ALz4NHJyn2ghC5boR53H3ioB2+7tcJunE=";
  };

  vendorHash = null;
  ldflags = [ "-X main.progVersion=${version}" ];

<<<<<<< HEAD
  meta = {
    description = "Tool to cast YouTube videos from the command-line";
    homepage = "https://github.com/MarcoLucidi01/ytcast";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ waelwindows ];
=======
  meta = with lib; {
    description = "Tool to cast YouTube videos from the command-line";
    homepage = "https://github.com/MarcoLucidi01/ytcast";
    license = licenses.mit;
    maintainers = with maintainers; [ waelwindows ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ytcast";
  };
}
