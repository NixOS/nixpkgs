{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, fonttools, lxml, fs
, setuptools_scm
, pytest, pytestcov, pytest_xdist, pytest-randomly
}:

buildPythonPackage rec {
  pname = "psautohint";
  version = "2.1.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner  = "adobe-type-tools";
    repo   = pname;
    sha256 = "00n9bycjmvx1fb4332bdj53f01q86ajndrvid9idpiyzybmd5vp4";
    rev    = "v${version}";
    fetchSubmodules = true; # data dir for tests
  };

  postPatch = ''
    echo '#define PSAUTOHINT_VERSION "${version}"' > libpsautohint/src/version.h
    sed -i '/use_scm_version/,+3d' setup.py
    sed -i '/setup(/a \     version="${version}",' setup.py
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ fonttools lxml fs ];

  checkInputs = [ pytest pytestcov pytest_xdist pytest-randomly ];
  checkPhase = "pytest tests";

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/adobe-type-tools/psautohint";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
