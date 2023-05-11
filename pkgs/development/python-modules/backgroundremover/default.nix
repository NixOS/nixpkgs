{ buildPythonPackage, fetchPypi, lib, certifi, charset-normalizer, ffmpeg-python
, filelock, filetype, hsh, idna, more-itertools, moviepy, numpy, pillow
, pymatting, pysocks, requests, scikitimage, scipy, six, torch, torchvision
, tqdm, urllib3, waitress, gdown }:
buildPythonPackage rec {
  pname = "backgroundremover";
  name = pname;
  version = "0.2.1";

  meta = with lib; {
    description =
      "BackgroundRemover is a command line tool to remove background from image and video, made by nadermx to power https://BackgroundRemoverAI.com";
    platforms = platforms.all;
    homepage = "https://github.com/nadermx/backgroundremover";
    downloadPage = "https://github.com/nadermx/backgroundremover/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ jayrovacsek ];
  };

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    ffmpeg-python
    filelock
    filetype
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
    gdown
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hh+NSFy2NgvgpsnTcFORzFfW4ZxX96nP4u9O+OpZw7Y=";
  };

  doCheck = false;

}
