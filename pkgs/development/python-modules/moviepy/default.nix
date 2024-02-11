{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, numpy
, decorator
, imageio
, imageio-ffmpeg
, proglog
, requests
, tqdm
  # Advanced image processing (triples size of output)
, advancedProcessing ? false
, scikit-image
, scikit-learn
, scipy
, matplotlib
, youtube-dl
}:

buildPythonPackage rec {
  pname = "moviepy";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2884e35d1788077db3ff89e763c5ba7bfddbd7ae9108c9bc809e7ba58fa433f5";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "decorator>=4.0.2,<5.0" "decorator>=4.0.2,<6.0"
  '';

  # No tests, require network connection
  doCheck = false;

  propagatedBuildInputs = [
    numpy
    decorator
    imageio
    imageio-ffmpeg
    tqdm
    requests
    proglog
  ] ++ lib.optionals advancedProcessing [
    scikit-image
    scikit-learn
    scipy
    matplotlib
    youtube-dl
  ];

  meta = with lib; {
    description = "Video editing with Python";
    homepage = "https://zulko.github.io/moviepy/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
