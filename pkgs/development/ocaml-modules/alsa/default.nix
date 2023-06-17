{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, alsa-lib }:

buildDunePackage rec {
  pname = "alsa";
  version = "0.3.0";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-alsa";
    rev = version;
    sha256 = "1qy22g73qc311rmv41w005rdlj5mfnn4yj1dx1jhqzr31zixl8hj";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ alsa-lib ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-alsa";
    description = "OCaml interface for libasound2";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
