{ lib, fetchFromGitHub }:

rec {
  version = "1.1.7";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-0QDy0ZUAtojYIuNliiDV2uywBnWxtKUhZ/LPqkfSOZ4=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
