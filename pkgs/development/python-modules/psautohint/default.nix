{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, fonttools
, lxml, fs # for fonttools extras
, setuptools_scm
, pytestCheckHook, pytest_5, pytestcov, pytest_xdist
}:

buildPythonPackage rec {
  pname = "psautohint";
  version = "2.2.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gsgfr190xy2rnjf1gf7688xrh13ihgq10s19s4rv5hp6pmg9iaa";
    fetchSubmodules = true; # data dir for tests
  };

  postPatch = ''
    echo '#define PSAUTOHINT_VERSION "${version}"' > libpsautohint/src/version.h
    sed -i '/use_scm_version/,+3d' setup.py
    sed -i '/setup(/a \     version="${version}",' setup.py
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ fonttools lxml fs ];

  checkInputs = [
    # Override pytestCheckHook to use pytest v5, because some tests fail on pytest >= v6
    # https://github.com/adobe-type-tools/psautohint/issues/284#issuecomment-742800965
    # Override might be able to be removed in future, check package dependency pins (coverage.yml)
    (pytestCheckHook.override{ pytest = pytest_5; })
    pytestcov
    pytest_xdist
  ];
  disabledTests = [
    # Slow tests, reduces test time from ~5 mins to ~30s
    "test_mmufo"
    "test_flex_ufo"
    "test_ufo"
    "test_flex_otf"
    "test_multi_outpath"
    "test_mmhint"
    "test_otf"
  ];

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/adobe-type-tools/psautohint";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
