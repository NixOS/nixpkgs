{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  base,
  fmt,
}:

buildDunePackage (finalAttrs: {
  pname = "genspio";
  version = "0.0.3";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "genspio";
    rev = "genspio.${finalAttrs.version}";
    hash = "sha256-TkF95GXkuRulIKqTK+CoiIN5tL/kvQdDLLdFEKxlCJ0=";
  };

  propagatedBuildInputs = [
    base
    fmt
  ];

  # base v0.17 compatibility
  patches = [ ./genspio.patch ];

  doCheck = true;

  meta = {
    homepage = "https://smondet.gitlab.io/genspio-doc/";
    description = "Typed EDSL to generate POSIX Shell scripts";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
