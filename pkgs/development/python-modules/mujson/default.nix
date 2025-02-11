{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mujson";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J9nPGxDkLQje6AkL9cewNqmQ7Z+00TXBEr3p71E2cnE=";
  };

  # LICENSE file missing from src
  # https://github.com/mattgiles/mujson/issues/8
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "license_file = LICENSE" ""
  '';

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "mujson" ];

  meta = with lib; {
    description = "Use the fastest JSON functions available at import time";
    homepage = "https://github.com/mattgiles/mujson";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
  };
}
