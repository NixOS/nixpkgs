{ buildPythonPackage
, isPy27
, fetchPypi
, lib
, nose
, six
}:

buildPythonPackage rec {
  pname = "phx-class-registry";
  version = "3.0.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8RRirEEKjNo4wraoO1GiOQx9lSi671kctbVRsRq6KpI=";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ nose ];

  # Tests currently failing.
  doCheck = false;

  pythonImportsCheck = [ "class_registry" ];

  meta = with lib; {
    description = "Factory+Registry pattern for Python classes.";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
