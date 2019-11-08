{ buildPythonPackage
, fetchFromGitHub
, gmpy2
, isPy3k
, lib
}:

buildPythonPackage rec {
  pname = "crypto-commons";
  version = "unstable-2019-11-08";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "p4-team";
    repo = pname;
    rev = "8f54fae30c71fddbc75a6eab3b8bca1fee56fb69";
    sha256 = "1f5xwcqwc55b4ap2z173h38x5dny126iikp7rji0sfap6jm6gvxk";
  };

  checkInputs = [ gmpy2 ];

  meta = with lib; {
    description = "A small python module for common CTF crypto functions";
    homepage = "https://github.com/p4-team/crypto-commons";
    maintainers = [ maintainers.pamplemousse ];
  };
}
