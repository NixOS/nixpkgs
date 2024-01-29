{ lib
, buildPythonPackage
, fetchurl
, isPy3k
, setuptools
, colorama
, six
, texttable
, tqdm
}:

buildPythonPackage rec {
  pname = "rbtools";
  version = "1.0.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchurl {
    url = "https://downloads.reviewboard.org/releases/RBTools/${lib.versions.majorMinor version}/RBTools-${version}.tar.gz";
    sha256 = "577c2f8bbf88f77bda84ee95af0310b59111c156f48a5aab56ca481e2f77eaf4";
  };

  propagatedBuildInputs = [ six texttable tqdm colorama setuptools ];

  # The kgb test dependency is not in nixpkgs
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.reviewboard.org/docs/rbtools/dev/";
    description = "RBTools is a set of command line tools for working with Review Board and RBCommons";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
