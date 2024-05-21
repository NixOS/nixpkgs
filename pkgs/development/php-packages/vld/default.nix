{
  lib,
  buildPecl,
  fetchFromGitHub,
}:

let
  version = "0.18.0";
in
buildPecl {
  inherit version;

  pname = "vld";

  src = fetchFromGitHub {
    owner = "derickr";
    repo = "vld";
    rev = version;
    hash = "sha256-1xMStPM3Z5qIkrRGfCKcYT6UdF1j150nt7IleirjdBM=";
  };

  # Tests relies on PHP 7.0
  doCheck = false;

  meta = {
    changelog = "https://github.com/derickr/vld/releases/tag/${version}";
    description = "The Vulcan Logic Dumper hooks into the Zend Engine and dumps all the opcodes (execution units) of a script.";
    homepage = "https://github.com/derickr/vld";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gaelreyrol ];
  };
}
