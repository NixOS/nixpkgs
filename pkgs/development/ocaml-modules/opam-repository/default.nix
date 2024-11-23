{ lib, buildDunePackage, opam-format, curl }:

buildDunePackage {
  pname = "opam-repository";

  inherit (opam-format) src version;

  patches = [ ./download-tool.patch ];
  postPatch = ''
    substituteInPlace src/repository/opamRepositoryConfig.ml \
      --replace-fail "SUBSTITUTE_NIXOS_CURL_PATH" "\"${curl}/bin/curl\""
  '';

  propagatedBuildInputs = [ opam-format ];

  configureFlags = [ "--disable-checks" ];

  meta = opam-format.meta // {
    description = "OPAM repository and remote sources handling, including curl/wget, rsync, git, mercurial, darcs backends";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
