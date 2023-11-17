{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyquaternion
, numpy
, poetry-core
}:

buildPythonPackage rec {
  pname = "bbox";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GGQhKkdwmrYPEhtldPY3WUInSniU/B40NZvt1gXEuzg=";
  };

  propagatedBuildInputs = [ pyquaternion numpy ];
  buildInputs = [ poetry-core ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "bbox" ];

  meta = with lib; {
    description = "Python library for 2D/3D bounding boxes";
    homepage = "https://github.com/varunagrawal/bbox";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
