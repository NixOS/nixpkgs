{ lib, fetchFromGitHub }:

rec {
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MWO8B/L/KHLuq/BIIIidsLbFwGIwt/xj+/M1zEp8Z/8=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
