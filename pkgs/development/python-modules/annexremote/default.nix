{ lib
, isPy3k
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, nose
}:

buildPythonPackage rec {
  pname = "annexremote";
  version = "1.3.1";

  # use fetchFromGitHub instead of fetchPypi because the test suite of
  # the package is not included into the PyPI tarball
  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Lykos153";
    repo = "AnnexRemote";
    sha256 = "13ny7h41430pi9393dw3qgwxvzcxacapjsw0d3vjm7lc4h566alq";
  };

  propagatedBuildInputs = [ future ];

  checkInputs = [ nose ] ++ lib.optional (!isPy3k) mock;
  checkPhase = "nosetests -v";

  meta = with lib; {
    description = "Helper module to easily develop git-annex remotes";
    homepage = https://github.com/Lykos153/AnnexRemote;
    license = licenses.gpl3;
    maintainers = with maintainers; [ montag451 ];
  };
}
