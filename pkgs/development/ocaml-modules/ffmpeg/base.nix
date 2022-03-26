{ lib, fetchFromGitHub }:

rec {
  version = "1.1.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "v${version}";
    sha256 = "13rc3d0n963a28my5ahv78r82rh450hvbsc74mb6ld0r9v210r0p";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
