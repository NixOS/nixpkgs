{
  alcobar,
  buildDunePackage,
  dune-build-info,
  fetchFromGitHub,
  lambdasoup,
  lib,
  logs,
  mdx,
  memtrace,
  psq,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "cascade";
  version = "0.0.0+git20260626.434c07b-1";
  minimalOCamlVersion = "5.2";
  duneVersion = "3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samoht";
    repo = "cascade";
    rev = "434c07be7ec1a63213a234946d57937e4d080feb";
    hash = "sha256-6g8UKsXdR0PxihrOiMVC36q7+bomMByPDbmuISL7h4U=";
  };

  propagatedBuildInputs = [
    dune-build-info
    logs
    psq
    uutf
  ];
  buildInputs = [
    lambdasoup
    memtrace
  ];

  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [
    (mdx.override { inherit logs; })
    alcobar
  ];
  doCheck = true;

  meta = {
    description = "CSS generation and manipulation library for OCaml";
    homepage = "https://github.com/samoht/cascade";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
