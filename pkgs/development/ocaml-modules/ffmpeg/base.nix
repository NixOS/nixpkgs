{ lib, fetchFromGitHub }:

rec {
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-XqZATaxpW0lEdrRTXVTc0laQAx437+eoa/zOzZV1kHk=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
