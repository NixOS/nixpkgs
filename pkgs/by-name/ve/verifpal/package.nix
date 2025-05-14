{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pigeon,
}:

buildGoModule rec {
  pname = "verifpal";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "symbolicsoft";
    repo = "verifpal";
    rev = "v${version}";
    hash = "sha256-kBeQ7U97Ezj85A/FbNnE1dXR7VJzx0EUrDbzwOgKl8E=";
  };

  vendorHash = "sha256-FvboLGdT+/W5on7NSzRp9QfV2peNVICypSFWAGFakLU=";

  nativeBuildInputs = [ pigeon ];

  subPackages = [ "cmd/verifpal" ];

  # goversioninfo is for Windows only and can be skipped during go generate
  preBuild = ''
    substituteInPlace cmd/verifpal/main.go --replace "go:generate goversioninfo" "(disabled goversioninfo)"
    go generate verifpal.com/cmd/verifpal
  '';

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    mainProgram = "verifpal";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
  };
}
