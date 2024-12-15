{
  buildDunePackage,
  httpun-types,
  angstrom,
  bigstringaf,
  faraday,
  alcotest,
}:

buildDunePackage {
  pname = "httpun";

  inherit (httpun-types) src version;

  propagatedBuildInputs = [
    angstrom
    bigstringaf
    faraday
    httpun-types
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = httpun-types.meta // {
    description = "A high-performance, memory-efficient, and scalable HTTP library for OCaml";
  };
}
