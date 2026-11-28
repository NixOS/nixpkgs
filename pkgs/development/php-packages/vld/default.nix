{
  lib,
  buildPecl,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

buildPecl (finalAttrs: {
  pname = "vld";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "derickr";
    repo = "vld";
    tag = finalAttrs.version;
    hash = "sha256-fNmDH5jUwwYYgIpDSvb+NVcg+q97QzKCcx1uaMBwDrs=";
  };

  # Tests relies on PHP 7.0
  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Vulcan Logic Dumper hooks into the Zend Engine and dumps all the opcodes (execution units) of a script";
    homepage = "https://github.com/derickr/vld";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    broken = lib.versionOlder php.version "8.2";
  };
})
