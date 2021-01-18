{ lib, buildDunePackage, unzip, opam-format, curl }:

buildDunePackage rec {
  pname = "opam-repository";

  minimumOCamlVersion = "4.02";

  useDune2 = true;

  inherit (opam-format) src version;

  patches = [ ./download-tool.patch ];
  postPatch = ''
    substituteInPlace src/repository/opamRepositoryConfig.ml \
      --replace "SUBSTITUTE_NIXOS_CURL_PATH" "\"${curl}/bin/curl\""
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [ curl ];
  propagatedBuildInputs = [ opam-format ];

  meta = opam-format.meta // {
    description = "OPAM repository and remote sources handling, including curl/wget, rsync, git, mercurial, darcs backends";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
