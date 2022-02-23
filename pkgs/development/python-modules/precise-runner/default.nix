{ lib
, buildPythonPackage
, fetchPypi
, pyaudio
, pytestCheckHook
}:

let
  pname = "precise-runner";
  version = "0.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GkZCCftL8KP11aQoMQyypwSHoBprw6lg0d2pCviWuA0=";
  };

  propagatedBuildInputs = [
    pyaudio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "precise_runner"
  ];

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
