{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "morfessor";
  version = "2.0.6";

  format = "setuptools";

  src = fetchPypi {
    pname = "Morfessor";
    inherit version;
    hash = "sha256-uzvqwjQ0FyTF9kD2WAMHH2I3OlDbqFTVo5hWf5rvurI=";
  };

  checkPhase = "python -m unittest -v morfessor/test/*";

  pythonImportsCheck = [ "morfessor" ];

  meta = with lib; {
    description = "Tool for unsupervised and semi-supervised morphological segmentation";
    homepage = "https://github.com/aalto-speech/morfessor";
    license = licenses.bsd2;
    maintainers = with maintainers; [ misuzu ];
  };
}
