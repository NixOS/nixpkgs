{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, starlette
, fastapi
}:

buildPythonPackage rec {
  pname = "imia";
  version = "0.5.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4CzevO7xgo8Hb1JHe/eGEtq/KCrJM0hV/7SRV2wmux8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    starlette
    fastapi
  ];

  # running the real tests would require sqlalchemy 1.4 and starsessions 1.x
  doCheck = false;
  pythonImportsCheck = [ "imia" ];

  meta = with lib; {
    description = "An authentication library for Starlette and FastAPI";
    changelog = "https://github.com/alex-oleshkevich/imia/releases/tag/v${version}";
    homepage = "https://github.com/alex-oleshkevich/imia";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
