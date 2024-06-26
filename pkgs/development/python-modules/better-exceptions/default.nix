{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "better_exceptions";
  version = "0.3.3";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5Oa8GERNXwTm6JSxA4Hl6SHT1UQkBBgWLH21fp6zRTs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Pretty and helpful exceptions, automatically";
    homepage = "https://github.com/qix-/better-exceptions";
    license = licenses.mit;
    maintainers = [ ];
  };
}
