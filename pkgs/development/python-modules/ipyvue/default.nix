{ lib
, isPy27
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.5.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8549a7ac7dc45948a5f2735e17f97622313c7fea24ea3c1bd4a5ebf02bf5638";
  };

  propagatedBuildInputs = [ ipywidgets ];

  doCheck = false;  # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = with lib; {
    description = "Jupyter widgets base for Vue libraries.";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
