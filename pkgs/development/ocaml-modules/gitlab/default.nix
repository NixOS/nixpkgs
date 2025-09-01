{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
  cohttp-lwt,
  atdgen,
  atdgen-runtime,
  yojson,
  iso8601,
  stringext,
}:

buildDunePackage rec {
  pname = "gitlab";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "tmcgilchrist";
    repo = "ocaml-gitlab";
    rev = version;
    hash = "sha256-7pUpH1SoP4eW8ild5j+Tcy+aTXq0+eSkhKUOXJ6Z30k=";
  };

  postPatch = ''
    substituteInPlace lib/dune --replace-warn 'atdgen str' 'atdgen-runtime str'
  '';

  minimalOCamlVersion = "4.08";

  buildInputs = [ stringext ];

  nativeBuildInputs = [ atdgen ];

  propagatedBuildInputs = [
    uri
    cohttp-lwt
    atdgen-runtime
    yojson
    iso8601
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/tmcgilchrist/ocaml-gitlab";
    description = "Native OCaml bindings to Gitlab REST API v4";
    license = licenses.bsd3;
    changelog = "https://github.com/tmcgilchrist/ocaml-gitlab/releases/tag/${version}";
    maintainers = with maintainers; [ zazedd ];
  };
}
