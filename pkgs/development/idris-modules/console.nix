{
  build-idris-package,
  fetchFromGitHub,
  idrisscript,
  hrtime,
  webgl,
  lib,
}:
build-idris-package {
  pname = "console";
  version = "2017-04-20";

  idrisDeps = [
    idrisscript
    hrtime
    webgl
  ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-console";
    rev = "14b6bd6bf6bd78dd3935e3de12e16f8ee41e29e4";
    sha256 = "0cn4fwnf3sg6269pbfbhnmsvyaya4d8479n2hy039idxzzkxw0yb";
  };

  meta = {
    description = "Idris library to interact with the browser console";
    homepage = "https://github.com/pierrebeaucamp/idris-console";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
