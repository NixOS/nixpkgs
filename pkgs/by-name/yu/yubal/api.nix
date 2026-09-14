{
  yubal,
  python312Packages,
}:

with python312Packages;
buildPythonPackage {
  pname = yubal.pname + "-api";
  inherit (yubal) version src;
  sourceRoot = "source/packages/api";
  pyproject = true;

  build-system = [
    uv-build
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.23,<0.12.0" "uv-build" \
      --replace-fail "alembic>=1.18.3" "alembic"
  '';

  pythonImportsCheck = [ "yubal_api" ];

  dependencies = [
    alembic
    croniter
    fastapi
    rich
    pydantic-settings
    sqlmodel
    tzdata
    uvicorn
    yubal.yubal-cli
  ];
}
