{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, unicodecsv
, pyyaml
, regex
, numpy
, editdistance
, munkres
}:

buildPythonPackage rec {
  pname = "panphon";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "dmort27";
    repo = "panphon";
    rev = "refs/tags/${version}";
    hash = "sha256-uKiTOJ3pPy1mZQHNPsEaomXPWRSClSGoY7dpa11lAuI=";
  };

  propagatedBuildInputs = [
    setuptools
    unicodecsv
    pyyaml
    regex
    numpy
    editdistance
    munkres
  ];

  meta = with lib; {
    changelog = "https://github.com/dmort27/panphon/releases/tag/${version}";
    description = "Python package and data files for manipulating phonological segments (phones, phonemes) in terms of universal phonological features.";
    homepage = "https://github.com/dmort27/panphon";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
