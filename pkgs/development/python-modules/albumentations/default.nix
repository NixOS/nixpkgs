{ fetchPypi
, buildPythonPackage
, lib
, numpy
, scipy
, scikitimage
, pyyaml
, qudida
, pytorch
, torchvision
, imgaug
, pytest
, opencv3
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.1.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "YLBnswk5CLzFKtsqpdRPV+vbuKtXpHsLQvPcHTsc6CQ=";
  };
  propagatedBuildInputs = [
    numpy
    scipy
    scikitimage
    pyyaml
    qudida
  ];

  checkInputs = [ pytest pytorch torchvision imgaug opencv3 ];
  ## the subsitute stops it from fishing for a source of opencv which we provide with opencv3
  postPatch = ''
    substituteInPlace setup.py --replace \
        "install_requires=get_install_requirements(INSTALL_REQUIRES, CHOOSE_INSTALL_REQUIRES)" \
        "install_requires=INSTALL_REQUIRES"
  '';
  pythonImportsCheck = [ "albumentations" ];

  meta = with lib; {
    description = "Python library for image augmentation";
    homepage = "https://github.com/albumentations-team/albumentations";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cfhammill ];
  };
}
