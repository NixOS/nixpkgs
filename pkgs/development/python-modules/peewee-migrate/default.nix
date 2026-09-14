{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # runtime
  click,
  peewee,

  # tests
  psycopg2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "peewee-migrate";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "peewee_migrate";
    tag = version;
    hash = "sha256-AFZW4vVHAuvdjA3t37YcOqVmwhZ1sU25L+YVP7BvMhQ=";
  };

  postPatch = ''
    sed -i '/addopts/d' pyproject.toml

    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.2,<0.11.0" uv_build
  '';

  nativeBuildInputs = [ uv-build ];

  propagatedBuildInputs = [
    peewee
    click
  ];

  pythonImportsCheck = [ "peewee_migrate" ];

  nativeCheckInputs = [
    psycopg2
    pytestCheckHook
  ];

  meta = {
    description = "Simple migration engine for Peewee";
    homepage = "https://github.com/klen/peewee_migrate";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
