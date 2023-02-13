{ lib, fetchFromGitHub }:

rec {
  version = "1.1.6";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-NlWmt98QwuGFNP8FHnAR3C0DIiSfJ1ZJXeVFFZiOSXs=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
