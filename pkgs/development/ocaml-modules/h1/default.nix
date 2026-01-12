{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom,
  base64,
  bstr,
  faraday,
  httpun-types,
  alcotest,
  version ? "1.1.0",
}:

buildDunePackage {
  inherit version;

  pname = "h1";

  src = fetchurl {
    url = "https://github.com/robur-coop/ocaml-h1/releases/download/v${version}/h1-${version}.tbz";
    hash = "sha256-LTBn7TgBY5IBSfvpFJ1b2mMLT0XjwQvnk77qBqB8bTw=";
  };

  propagatedBuildInputs = [
    angstrom
    base64
    bstr
    faraday
    httpun-types
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = {
    description = "High-performance, memory-efficient, and scalable web server for OCaml";
    homepage = "https://github.com/robur-coop/ocaml-h1";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.bsd3;
  };
}
