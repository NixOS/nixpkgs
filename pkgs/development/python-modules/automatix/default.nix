{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pyyaml
, importlib-metadata
, withBundlewrap ? true, bundlewrap
, withBundlewrapTeamvault ? withBundlewrap, bundlewrap-teamvault
, pytest
}:

assert withBundlewrapTeamvault -> withBundlewrap;

buildPythonPackage rec {
  pname = "automatix";
  version = "1.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lgft8lUUu8kKpoSutw7VxRz6Ktws2HG+0H7KfSoSFrA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml importlib-metadata ]
    ++ lib.optional withBundlewrap bundlewrap
    ++ lib.optional withBundlewrapTeamvault bundlewrap-teamvault;

  buildInputs = [ pytest ];

  # Tests are currently broken
  # Also, there's only integration tests requiring a docker setup
  doCheck = false;

  pythonImportsCheck = [
    "automatix"
  ];

  meta = with lib; {
    homepage = "https://github.com/seibert-media/automatix";
    description = "Automation wrapper for bash and python commands";
    license = licenses.mit;
    maintainers = with maintainers; [ hexchen ];
  };
}
