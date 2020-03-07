{ stdenv, fetchPypi, buildPythonPackage, pythonOlder
, bottleneck, fastprogress, beautifulsoup4, matplotlib, numexpr, numpy
, nvidia-ml-py3, pandas, packaging, pillow, pyyaml, requests, scipy, pytorch
, spacy, torchvision, scikitimage, dataclasses
, pytest, pytestrunner, coverage, distro, ipython, jupyter, nbconvert, nbdime
, nbformat, notebook, responses, traitlets }:

buildPythonPackage rec {
  pname = "fastai";
  version = "1.0.60";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h96nkn02zbn6qd2nkfxkhbx6jspgj9y7d9cx6p645573f2cajza";
  };

  # pynvx - darwin
  propagatedBuildInputs = [
    bottleneck fastprogress beautifulsoup4 matplotlib numexpr numpy
    nvidia-ml-py3 pandas packaging pillow pyyaml requests scipy pytorch spacy
    torchvision scikitimage
  ] ++ stdenv.lib.optional (pythonOlder "3.7") dataclasses;

  dontUseSetuptoolsCheck = true;

  checkInputs = [
    pytest pytestrunner
    coverage distro ipython jupyter nbconvert nbdime nbformat notebook responses
    traitlets
  ];

  meta = with stdenv.lib; {
    description = "The fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eadwu ];
  };
}
