{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "webwormhole";
  version = "0-unstable-2025-12-22";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = "webwormhole";
    rev = "abf852af0458ba79772d9c26ef01434165f217d8";
    hash = "sha256-hP5MtIoGod3FS4TipNkgoyo43HWnywPintqpjmvrTc8=";
  };

  vendorHash = "sha256-ULlaicl4o/YyHSS64Q2hsl5l5Mm3C6cBG8zaxrEijOU=";

  meta = {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
