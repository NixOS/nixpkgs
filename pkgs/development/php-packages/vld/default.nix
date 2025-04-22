{
  lib,
  buildPecl,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

buildPecl {
  pname = "vld";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "derickr";
    repo = "vld";
    rev = "dc56f73a25b0230745afb5523871f2e8dd33fccd";
    hash = "sha256-pQ1KIdGtV7bN5nROOJHR7C1eFMqVioTNLPAsJzH86NI=";
  };

  # Tests relies on PHP 7.0
  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Vulcan Logic Dumper hooks into the Zend Engine and dumps all the opcodes (execution units) of a script";
    homepage = "https://github.com/derickr/vld";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    broken = lib.versionOlder php.version "8.2";
  };
}
