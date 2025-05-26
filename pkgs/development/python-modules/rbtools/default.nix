{
  lib,
  buildPythonPackage,
  fetchurl,
  isPy3k,
  setuptools,
  colorama,
  six,
  texttable,
  tqdm,
}:

buildPythonPackage rec {
  pname = "rbtools";
  version = "5.2.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchurl {
    url = "https://downloads.reviewboard.org/releases/RBTools/${lib.versions.majorMinor version}/RBTools-${version}.tar.gz";
    sha256 = "f2863515ef6ff1cfcd3905d5f409ab8c4d12878b364d6f805ba848dcaecb97f2";
  };

  propagatedBuildInputs = [
    six
    texttable
    tqdm
    colorama
    setuptools
  ];

  # The kgb test dependency is not in nixpkgs
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.reviewboard.org/docs/rbtools/dev/";
    description = "RBTools is a set of command line tools for working with Review Board and RBCommons";
    mainProgram = "rbt";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
