{ lib, buildDunePackage, fetchFromGitHub, ocaml_pcre }:

buildDunePackage rec {
  pname = "duppy";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-duppy";
    rev = "v${version}";
    sha256 = "132dawca1p5s965m40ldmnihlpgfm47y62kfbzgim7sgsdwxxw5y";
  };

  propagatedBuildInputs = [ ocaml_pcre ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-duppy";
    description = "Library providing monadic threads";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
