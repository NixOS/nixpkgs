{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.19.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1OLUJxsuxG/sCKDxKiU4i7o5HyaJdIW8rPo8UofMI28=";
  };

  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = false;

  meta = with lib; {
    description = "PEP-484 stubs for Celery";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
