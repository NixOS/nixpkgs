{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_monad";
  version = "0.2.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "niols";
    repo = "ppx_monad";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cbguAddSlUxBK7pmT7vNmtJW9TrVZZjdSJRMT3lqxOA=";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  doCheck = true;
  checkInputs = [
  ];

  meta = {
    description = "OCaml Syntax Extension for all Monadic Syntaxes";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.niols ];
    homepage = "https://github.com/niols/ppx_monad";
  };
})
