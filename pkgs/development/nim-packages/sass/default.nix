{ buildNimPackage, fetchFromGitHub, libsass }:

buildNimPackage rec {
  pname = "sass";
  version = "e683aa1";
  src = fetchFromGitHub {
    owner = "dom96";
    repo = pname;
    rev = version;
    sha256 = "0qvly5rilsqqsyvr67pqhglm55ndc4nd6v90jwswbnigxiqf79lc";
  };
  propagatedBuildInputs = [ libsass ];
}
