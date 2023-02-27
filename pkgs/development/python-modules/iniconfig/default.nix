{ lib
, buildPythonPackage
, substituteAll
, fetchPypi
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "2.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LZHhNb9y0xpBCxfBbaYQqCy1X2sEd9GpAhNLJKRVuLM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  patches = [
    # Cannot use hatch-vcs, due to an inifinite recursion
    (substituteAll {
      src = ./version.patch;
      inherit version;
    })
  ];

  pythonImportsCheck = [
    "iniconfig"
  ];

  doCheck = false; # avoid circular import with pytest

  meta = with lib; {
    description = "brain-dead simple parsing of ini files";
    homepage = "https://github.com/pytest-dev/iniconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
