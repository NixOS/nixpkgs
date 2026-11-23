{
  buildPecl,
  lib,
  fetchFromGitHub,
  judy,
}:

buildPecl (finalAttrs: {
  version = "3.1.0";
  pname = "memprof";

  src = fetchFromGitHub {
    owner = "arnaud-lb";
    repo = "php-memory-profiler";
    tag = finalAttrs.version;
    hash = "sha256-gq+txAU2Fw+Zm1aIu0lwPUHRqtccNcHFpp0fm3f7BnQ=";
  };

  buildInputs = [
    judy
  ];
  configureFlags = [
    "--with-judy-dir=${lib.getDev judy}"
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/arnaud-lb/php-memory-profiler/releases/tag/${finalAttrs.version}";
    description = "Memory profiler for PHP. Helps finding memory leaks in PHP scripts";
    homepage = "https://github.com/arnaud-lb/php-memory-profiler";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
