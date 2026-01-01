{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  bleak,
  pycayennelpp,
  pyserial-asyncio,
}:

buildPythonPackage rec {
  pname = "meshcore";
<<<<<<< HEAD
  version = "2.2.3";
=======
  version = "2.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-lmMflAlrNnfsc10J3CBxor9ftHK10bWyGTbjASJv82s=";
=======
    sha256 = "sha256-vn/vF4avMDwDLL0EMVrrMWkZrZ1GTiUxGyTBOtKvG1I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio
  ];

  pythonImportsCheck = [ "meshcore" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
=======
  meta = with lib; {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    license = licenses.mit;
    maintainers = [ maintainers.haylin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
