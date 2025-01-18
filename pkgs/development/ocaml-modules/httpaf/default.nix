{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  angstrom,
  faraday,
  result,
  alcotest,
}:

buildDunePackage rec {
  pname = "httpaf";
  version = "0.7.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "0zk78af3qyvf6w66mg8sxygr6ndayzqw5s3zfxibvn121xwni26z";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [
    angstrom
    faraday
    result
  ];
  doCheck = true;

  meta = with lib; {
    description = "High-performance, memory-efficient, and scalable web server for OCaml";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
