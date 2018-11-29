{ stdenv, buildPythonPackage, fetchFromGitHub, pillow, argparse, pyres, nose
, preggy, numpy, yanc, nose-focus, mock, opencv }:

buildPythonPackage rec {
  pname = "remotecv";
  version = "2.2.2";

  propagatedBuildInputs = [ pillow argparse pyres ];

  checkInputs = [ nose preggy numpy yanc nose-focus mock opencv ];

  # PyPI tarball doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "thumbor";
    repo = pname;
    rev = version;
    sha256 = "0slalp1x626ajy2cbdfifhxf0ffzckqdz6siqsqr6s03hrl877hy";
  };

  # Remove unnecessary argparse dependency and some seemingly unnecessary
  # version upper bounds because nixpkgs contains (or could contain) newer
  # versions.
  # See: https://github.com/thumbor/remotecv/issues/15
  patches = [
    ./install_requires.patch
  ];

  checkPhase = ''
    nosetests --with-yanc -s tests/
  '';

  meta = with stdenv.lib; {
    description = "OpenCV worker for facial and feature recognition";
    homepage = https://github.com/thumbor/remotecv/wiki;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
