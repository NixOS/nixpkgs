{ buildNimPackage, fetchFromGitHub, htslib }:

buildNimPackage rec {
  pname = "hts-nim";
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "brentp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0670phk1bq3l9j2zaa8i5wcpc5dyfrc0l2a6c21g0l2mmdczffa7";
  };
  propagatedBuildInputs = [ htslib ];
  doCheck = false;
}
