{
  lib,
  fetchPypi,
  buildPythonPackage,
  six,
  cssselect,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "leather";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+WS+wghvMVOmwW5wfyDLcY+BH1evEWB19MD0gFxgi5U=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    cssselect
    lxml
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    homepage = "http://leather.rtfd.io";
    description = "Python charting library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "http://leather.rtfd.io";
    description = "Python charting library";
    license = licenses.mit;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
