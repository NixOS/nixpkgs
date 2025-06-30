{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "memtrace";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dWkTrN8ZgNUz7BW7Aut8mfx8o4n8f6UZaDv/7rbbwNs=";
  };

  minimalOCamlVersion = "4.11";

  meta = with lib; {
    homepage = "https://github.com/janestreet/${pname}";
    description = "Streaming client for OCaml's Memprof";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
