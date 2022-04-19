{ lib, fetchFromGitHub }:

rec {
  version = "1.1.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "v${version}";
    sha256 = "1l40dfc0v3wn2drfq0mclrc1lrlpycdjrkrw4knkwpsg0za68v4c";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
