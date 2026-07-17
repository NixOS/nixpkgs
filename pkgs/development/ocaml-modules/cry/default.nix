{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "cry";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-cry";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ea6f2xTVmYekPmzAKasA9mNG4Voxw2MCkfZ9LB9gwbo=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace-warn bytes ""
  '';

  minimalOCamlVersion = "4.12";

  meta = {
    homepage = "https://github.com/savonet/ocaml-cry";
    description = "OCaml client for the various icecast & shoutcast source protocols";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
