{ buildPythonPackage, lib, fetchFromGitHub
, requests, tqdm
, nose, vcrpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "1.2.0";

  # Install from Pypi is failing because of a missing file (Changelog.rst)
  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jxaO8nCR5jhXCPjhjVLKaGeQp9JF3ECQ1+j3TOJKawg=";
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
