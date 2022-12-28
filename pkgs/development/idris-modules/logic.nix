{ build-idris-package
, fetchFromGitHub
, bifunctors
, lib
}:
build-idris-package  {
  pname = "logic";
  version = "2016-12-02";

  idrisDeps = [ bifunctors ];

  src = fetchFromGitHub {
    owner = "yurrriq";
    repo = "idris-logic";
    rev = "e0bed57e17fde1237fe0358cb77b25f488a04d2f";
    sha256 = "0kvn1p0v71vkwlchf20243c47jcfid44w5r0mx4dydijq9gylxfz";
  };

  # tests fail
  doCheck = false;

  meta = {
    description = "Propositional logic tools, inspired by the Coq standard library";
    homepage = "https://github.com/yurrriq/idris-logic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
