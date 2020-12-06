{ lib, fetchFromGitHub, fetchpatch, buildDunePackage
, angstrom, faraday, alcotest
}:

buildDunePackage rec {
  pname = "httpaf";
  version = "0.6.6";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "065ikryv8zw9cbk6ddcjcind88ckk0inz9m3sqj9nwyfw4v4scm6";
  };

  patches = [
    # Fix tests with angstrom ≥ 0.14
    (fetchpatch {
      url = "https://github.com/inhabitedtype/httpaf/commit/fc0de5f2f1bd8df953ae4d4c9a61032392436c84.patch";
      sha256 = "1a8ca76ifbgyaq1bqfyq18mmxinjjparzkrr7ljbj0y1z1rl748z";
    })
  ];

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ angstrom faraday ];
  doCheck = true;

  meta = {
    description = "A high-performance, memory-efficient, and scalable web server for OCaml";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
