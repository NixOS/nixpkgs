{ lib, fetchFromGitHub }:

rec {
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ffmpeg";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Df+dU7Cd1rgsC/TelPzQ7wYlwsX9MGd8qcYsVN6dyMg=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ffmpeg";
    description = "Bindings for the ffmpeg libraries";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
