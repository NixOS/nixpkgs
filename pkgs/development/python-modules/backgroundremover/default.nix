{ buildPythonPackage
, certifi
, charset-normalizer
, fetchPypi
, ffmpeg-python
, filelock
, filetype
, gdown
, hsh
, idna
, lib
, more-itertools
, moviepy
, numpy
, pillow
, pymatting
, pysocks
, requests
, scikitimage
, scipy
, six
, torch
, torchvision
, tqdm
, urllib3
, waitress
}:

buildPythonPackage rec {
  pname = "backgroundremover";

  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hh+NSFy2NgvgpsnTcFORzFfW4ZxX96nP4u9O+OpZw7Y=";
  };

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    ffmpeg-python
    filelock
    filetype
    gdown
    hsh
    idna
    more-itertools
    moviepy
    numpy
    pillow
    pymatting
    pysocks
    requests
    scikitimage
    scipy
    six
    torch
    torchvision
    tqdm
    urllib3
    waitress
  ];

  doCheck = false;

  meta = with lib; {
    description =
      "BackgroundRemover is a command line tool to remove background from image and video, made by nadermx to power https://BackgroundRemoverAI.com";
    platforms = platforms.all;
    homepage = "https://github.com/nadermx/backgroundremover";
    downloadPage = "https://github.com/nadermx/backgroundremover/releases";
    license = licenses.mit;
    maintainers = [ maintainers.jayrovacsek ];
  };

}
