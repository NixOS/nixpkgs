{ lib, buildPythonPackage, fetchPypi, pytest, pytest-runner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "809de3a97c68afa831f7101b10d316fe62e061dc9f7f67a44b7738128721173a";
  };

  # Some kind of trickery with imports that doesn't work.
  doCheck = false;
  buildInputs = [ pytest pytest-runner ];
  propagatedBuildInputs = [ six regex ];

  meta = with lib; {
    homepage = "https://github.com/Toilal/rebulk/";
    license = licenses.mit;
    description = "Advanced string matching from simple patterns";
  };
}
