{ lib, buildDunePackage, fetchFromGitHub
}:

buildDunePackage rec {
  pname = "memtrace";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y/Xz04CMFfRIzrDzGot16zEQsBMNc4J5s/q0VERcj04=";
  };

  minimalOCamlVersion = "4.11";

  meta = with lib; {
    homepage = "https://github.com/janestreet/${pname}";
    description = "Streaming client for OCaml's Memprof";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
