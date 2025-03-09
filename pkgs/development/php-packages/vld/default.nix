{
  lib,
  buildPecl,
  fetchFromGitHub,
}:

buildPecl {
  pname = "vld";
  version = "0.18.0-unstable-2024-08-22";

  src = fetchFromGitHub {
    owner = "derickr";
    repo = "vld";
    rev = "dc56f73a25b0230745afb5523871f2e8dd33fccd";
    hash = "sha256-pQ1KIdGtV7bN5nROOJHR7C1eFMqVioTNLPAsJzH86NI=";
  };

  # Tests relies on PHP 7.0
  doCheck = false;

  meta = {
    description = "Vulcan Logic Dumper hooks into the Zend Engine and dumps all the opcodes (execution units) of a script";
    homepage = "https://github.com/derickr/vld";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gaelreyrol ];
  };
}
