{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-mock,
  bitvector-for-humans,
  hidapi,
  loguru,
  pyserial,
  typer,
  webcolors,
}:
buildPythonPackage rec {
  pname = "busylight-for-humans";
  version = "0.28.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    rev = version;
    hash = "sha256-OGcq+mrjaKUIAyLR8tknX+I5EDmVCBVZE406K4+PaWc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry>=0.12' 'poetry-core' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [
    poetry-core
    pytestCheckHook
    pytest-mock
  ];
  propagatedBuildInputs = [
    bitvector-for-humans
    hidapi
    loguru
    pyserial
    typer
    webcolors
  ];

  disabledTestPaths = [ "tests/test_pydantic_models.py" ];

  pythonImportsCheck = [ "busylight" ];

  meta = with lib; {
    homepage = "https://github.com/JnyJny/busylight";
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ conni2461 ];
  };
}
