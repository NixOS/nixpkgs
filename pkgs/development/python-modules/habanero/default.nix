{ buildPythonPackage, lib, fetchFromGitHub
, requests, tqdm
, nose, vcrpy
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "0.7.4";

  # Install from Pypi is failing because of a missing file (Changelog.rst)
  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d8yj9xz5qabcj57rpjzvg0jcscvzrpb0739mll29nijbsaimfr1";
  };

  propagatedBuildInputs = [ requests tqdm ];

  checkInputs = [ nose vcrpy ];
  checkPhase = "make test";

  meta = {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
