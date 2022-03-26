{ lib, fetchFromGitHub, buildDunePackage, dune-configurator
, fdk_aac
}:

buildDunePackage rec {
  pname = "fdkaac";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-fdkaac";
    rev = version;
    sha256 = "10i6hsjkrpw7zgx99zvvka3sapd7zy53k7z4b6khj9rdrbrgznv8";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ fdk_aac ];

  meta = {
    description = "OCaml binding for the fdk-aac library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.vbgl lib.maintainers.dandellion ];
  };

}
