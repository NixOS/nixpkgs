{
  buildDunePackage,
  fetchFromGitHub,
  lib,
  uutf,
}:

buildDunePackage rec {
  pname = "terml";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "wllfaria";
    repo = "terml";
    rev = "${version}";
    hash = "sha256-2ifMfUaYYsCFOACgXgJ5IuoSEicHyIqumLpun2ZqcDc=";
  };

  propagatedBuildInputs = [ uutf ];

  minimalOCamlVersion = "4.13";

  meta = {
    changelog = "https://github.com/wllfaria/terml/blob/${version}/CHANGES.md";
    description = "Terminal manipulation library in pure Ocaml";
    homepage = "https://github.com/wllfaria/terml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.PhilVoel ];
  };
}
