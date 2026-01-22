{ lib, fetchFromGitHub }:

rec {
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    tag = "v${version}";
    hash = "sha256-MWO8B/L/KHLuq/BIIIidsLbFwGIwt/xj+/M1zEp8Z/8=";
  };

  meta = {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    changelog = "https://raw.githubusercontent.com/savonet/ocaml-ffmpeg/refs/tags/${src.tag}/CHANGES";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      dandellion
      momeemt
    ];
  };
}
