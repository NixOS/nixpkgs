{ lib
, buildPythonPackage, fetchPypi
, numpy, requests, six, pyglet, scipy, cloudpickle
}:

buildPythonPackage rec {
  pname = "gym";
  version = "0.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb495aa56995b01274a2213423bf5ba05b8f4fd51c6dc61e9d4abddd1189718e";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyglet>=1.2.0,<=1.3.2" "pyglet" \
      --replace "cloudpickle>=1.2.0,<1.4.0" "cloudpickle~=1.2"
  '';
  # cloudpickle range has been expanded in package but not yet released

  propagatedBuildInputs = [
    numpy requests six pyglet scipy cloudpickle
  ];

  # The test needs MuJoCo that is not free library.
  doCheck = false;

  pythonImportCheck = [ "gym" ];

  meta = with lib; {
    description = "A toolkit by OpenAI for developing and comparing your reinforcement learning agents";
    homepage = "https://gym.openai.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
