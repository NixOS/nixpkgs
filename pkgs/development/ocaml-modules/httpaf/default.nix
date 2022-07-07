{ lib, fetchFromGitHub, fetchpatch, buildDunePackage
, angstrom, faraday, alcotest
}:

buildDunePackage rec {
  pname = "httpaf";
  version = "0.7.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "0zk78af3qyvf6w66mg8sxygr6ndayzqw5s3zfxibvn121xwni26z";
  };

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
