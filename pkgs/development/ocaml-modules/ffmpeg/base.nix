{ lib, fetchFromGitHub }:

rec {
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Tr0YhoaaUSOlA7vlhAjPyFJI/iL7Z54oO27RnG7d+nA=";
  };

  meta = {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
