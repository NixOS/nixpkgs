{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, tempora, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31716fe84d3d5df39d95572942513bd4bf8ae0a478f64031eff4c2ea9e83434e";
  };

  patches = [ ./0001-Don-t-run-flake8-checks-during-the-build.patch ];

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ tempora six ];
  checkInputs = [ pytest ];

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    description = "Support for Python logging facility";
    homepage = "https://github.com/jaraco/jaraco.logging";
    license = licenses.mit;
  };
}
