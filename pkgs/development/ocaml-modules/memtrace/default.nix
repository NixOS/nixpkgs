{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "memtrace";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "memtrace";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dWkTrN8ZgNUz7BW7Aut8mfx8o4n8f6UZaDv/7rbbwNs=";
  };

  minimalOCamlVersion = "4.11";

  meta = {
    homepage = "https://github.com/janestreet/memtrace";
    description = "Streaming client for OCaml's Memprof";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niols ];
  };
})
