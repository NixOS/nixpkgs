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
    sha256 = "bb3beac234341724c5f640f65803071f62373a50dba854d5a398567f9aefbab2";
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
