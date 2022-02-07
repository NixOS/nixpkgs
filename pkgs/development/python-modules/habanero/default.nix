{ buildPythonPackage, lib, fetchFromGitHub
, requests, tqdm
, nose, vcrpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "1.0.0";

  # Install from Pypi is failing because of a missing file (Changelog.rst)
  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lhbd5c4sypcd65nh4cgxddsqrxwg89nn1qiii6m5l4fzsvblggv";
  };

  propagatedBuildInputs = [ requests tqdm ];

  # almost the entirety of the test suite makes network calls
  pytestFlagsArray = [
    "test/test-filters.py"
  ];

  checkInputs = [
    pytestCheckHook
    vcrpy
  ];

  meta = {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
