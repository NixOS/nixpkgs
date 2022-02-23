{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytestCheckHook
}:

let
  pname = "lingua-franca";
  version = "0.4.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    pname = "lingua_franca";
    inherit version;
    sha256 = "sha256-c0qrlKkM8bqzgW92Jf6y7jcXmb3kmMs3vU2j5JkOXzI=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "python-dateutil==2.6.0" "python-dateutil>=2.6.0"
  '';

  propagatedBuildInputs = [
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lingua_franca"
  ];

  meta = with lib; {
    description = "Mycroft's multilingual text parsing and formatting library";
    homepage = "https://github.com/MycroftAI/lingua-franca";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
