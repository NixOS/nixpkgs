{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  gnuplot,
  iso8601,
}:

buildDunePackage (finalAttrs: {
  pname = "gnuplot";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-gnuplot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CTIjZbDM6LX6/dR6hF9f8ipb99CDHLV0y9qfsuiI/wo=";
  };

  propagatedBuildInputs = [
    gnuplot
    iso8601
  ];

  meta = {
    homepage = "https://github.com/c-cube/ocaml-gnuplot";
    description = "OCaml bindings to Gnuplot";
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.lgpl21;
  };
})
