{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ytcast";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "MarcoLucidi01";
    repo = "ytcast";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qFKqyBaG3+IltuJ/UDeWxlBy1NqXRZ0ENGiQoTOrWI0=";
  };

  vendorHash = null;
  ldflags = [ "-X main.progVersion=${finalAttrs.version}" ];

  meta = {
    description = "Tool to cast YouTube videos from the command-line";
    homepage = "https://github.com/MarcoLucidi01/ytcast";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      waelwindows
      claes
    ];
    mainProgram = "ytcast";
  };
})
