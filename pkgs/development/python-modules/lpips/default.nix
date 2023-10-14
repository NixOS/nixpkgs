{ buildPythonPackage
, fetchPypi
, numpy
, tqdm
, scipy
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "lpips";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "OEYzHfbGloiuw9MApe7vbFKUNbyEYL1YIBw9YuVhiPo=";
  };

  propagatedBuildInputs =
    [ numpy tqdm scipy torch torchvision ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "Perceptual Similarity Metric and Dataset";
    homepage = "https://richzhang.github.io/PerceptualSimilarity/";
  };
}
