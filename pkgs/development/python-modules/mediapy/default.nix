{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
  ipython,
  matplotlib,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "mediapy";
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BSlHpnbr00kTWaaUOxRFWf3EFPdBsDoFx4+ntikeaxI=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    ipython
    matplotlib
    numpy
    pillow
  ];

  pythonImportsCheck = [ "mediapy" ];

  meta = with lib; {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    changelog = "https://github.com/google/mediapy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mcwitt ];
  };
}
