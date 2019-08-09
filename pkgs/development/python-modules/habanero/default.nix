{ buildPythonPackage, lib, fetchFromGitHub
, requests
, nose, vcrpy
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "0.6.0";

  # Install from Pypi is failing because of a missing file (Changelog.rst)
  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l2cgl6iiq8jff2w2pib6w8dwaj8344crhwsni2zzq0p44dwi13d";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ nose vcrpy ];
  checkPhase = "make test";

  meta = {
    description = "Python interface to Library Genesis";
    homepage = https://habanero.readthedocs.io/en/latest/;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
