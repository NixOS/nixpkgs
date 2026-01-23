{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  version = "1.1";
  pname = "timed";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-${pname}";
    rev = version;
    sha256 = "sha256-wUoI9j/j0IGYW2NfJHmyR2XEYfYejyoYLWnKsuWdFas=";
  };

  doCheck = true;

  meta = {
    description = "Timed references for imperative state";
    homepage = "https://github.com/rlepigre/ocaml-timed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
