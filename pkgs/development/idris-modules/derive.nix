{ build-idris-package
, fetchFromGitHub
, contrib
, pruviloj
, lib
}:
build-idris-package  {
  name = "derive";
  version = "2018-07-02";

  idrisDeps = [ contrib pruviloj ];

  # https://github.com/david-christiansen/derive-all-the-instances/pull/9
  src = fetchFromGitHub {
    owner = "infinisil";
    repo = "derive-all-the-instances";
    rev = "61c3e12e26f599379299fcbb9c40a81bfc3e0604";
    sha256 = "0g2lb8nrwqwf3gm5fir43cxz6db84n19xiwkv8cmmqc1fgy6v0qn";
  };

  meta = {
    description = "Type class deriving with elaboration reflection";
    homepage = https://github.com/davlum/derive-all-the-instances;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
