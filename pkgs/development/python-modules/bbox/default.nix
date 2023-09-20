{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyquaternion
, numpy
}:

buildPythonPackage rec {
  pname = "bbox";
  version = "0.9.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ucR7mg9eubEefjC7ratEgrb9h++a26z8KV38n3N2kcw=";
  };

  propagatedBuildInputs = [ pyquaternion numpy ];

  pythonImportsCheck = [ "bbox" ];

  meta = with lib; {
    description = "Python library for 2D/3D bounding boxes";
    homepage = "https://github.com/varunagrawal/bbox";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
