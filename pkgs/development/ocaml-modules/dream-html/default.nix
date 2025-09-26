{
  lib,
  buildDunePackage,
  dream,
  pure-html,
  ppxlib,
}:

buildDunePackage {
  pname = "dream-html";
  inherit (pure-html) src version;

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    pure-html
    dream
  ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
}
