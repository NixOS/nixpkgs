{ lib, buildDunePackage, fetchFromGitHub, re }:

buildDunePackage rec {
  pname = "duppy";
  version = "0.9.4";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-duppy";
    rev = "v${version}";
    sha256 = "sha256-rVdfAMu26YgS/TZk2XPqaR6KTDLbh9Elkf8rjhSnNO4=";
  };

  propagatedBuildInputs = [ re ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-duppy";
    description = "Library providing monadic threads";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
