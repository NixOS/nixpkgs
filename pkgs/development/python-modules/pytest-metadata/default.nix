{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "2.0.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/NL0FvFb4pWUNSezyLoWpErlpxQZOckMPcXOnRZ88qU=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ pytest ];

  meta = with lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
