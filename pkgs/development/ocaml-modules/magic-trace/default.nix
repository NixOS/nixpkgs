{ lib
, fetchFromGitHub
, buildDunePackage
, ocaml-crunch
, angstrom
, async
, cohttp
, cohttp_static_handler ? null
, core
, core_unix ? null
, fzf
, owee
, ppx_jane
, re
, shell ? null
}:

buildDunePackage rec {
  pname = "magic-trace";
  version = "1.2.1";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "magic-trace";
    rev = "v${version}";
    hash = "sha256-/9TDjCG/06mhGyqbjAdUmk6fcaq9fNDqVSw51w5EEy4=";
  };

  nativeBuildInputs = [
    ocaml-crunch
  ];
  buildInputs = [
    angstrom
    async
    cohttp
    cohttp_static_handler
    core
    core_unix
    fzf
    owee
    ppx_jane
    re
    shell
  ];

  meta = with lib; {
    description =
      "Collects and displays high-resolution traces of what a process is doing";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/janestreet/magic-trace";
  };
}
