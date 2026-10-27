{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "idrisscript";
  version = "2017-07-01";

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "IdrisScript";
    rev = "4bb7019182392f24d2246a3e616f829156c8f091";
    hash = "sha256-ziXEj83PD2BJr4vAwwUZp1KiHtftTFueJZhjKKB9kRw=";
  };

  meta = {
    description = "FFI Bindings to interact with the unsafe world of JavaScript";
    homepage = "https://github.com/idris-hackers/IdrisScript";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
