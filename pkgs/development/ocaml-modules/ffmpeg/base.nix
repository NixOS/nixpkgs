{ lib, fetchFromGitHub }:

rec {
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    tag = "v${version}";
    hash = "sha256-wQvpbvAAg4tybAFdGq0O9vfCc0v2iPFk04Q3zgTwa7Y=";
  };

  meta = {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    changelog = "https://raw.githubusercontent.com/savonet/ocaml-ffmpeg/refs/tags/${src.tag}/CHANGES";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      dandellion
      momeemt
      juaningan
    ];
  };
}
