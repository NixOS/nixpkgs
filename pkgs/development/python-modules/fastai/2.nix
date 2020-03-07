{ stdenv, fetchFromGitHub, buildPythonPackage
, fastcore, pytorch, torchvision, matplotlib, pandas, requests, pyyaml
, fastprogress, pillow, scikitlearn, scipy, spacy }:

buildPythonPackage rec {
  pname = "fastai2";
  version = "2020-03-01";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai2";
    rev = "a76f0ce4fbd9ff3ebe4038c9fa4863308e0f6a0a";
    sha256 = "1a4sigw2vf53ifdg9z2v6cc30lvbk426kd06qj0740svkgwlsahi";
  };

  propagatedBuildInputs = [
    fastcore pytorch torchvision matplotlib pandas requests pyyaml fastprogress
    pillow scikitlearn scipy spacy
  ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "The fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
