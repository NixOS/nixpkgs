{
  aiosqlite,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  flask,
  flit-core,
  lib,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "flask-sqlalchemy-lite";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-sqlalchemy-lite";
    tag = version;
    hash = "sha256-LpdPp5Gp74DSJqD1DJqwNeaMKdN5pEAUkxnKGYZcVis=";
  };

  patches = [
    # fix python3.13 compat
    (fetchpatch2 {
      url = "https://github.com/pallets-eco/flask-sqlalchemy-lite/commit/b4117beaa6caa0a5945d6e3451db8b80dc4cc8cf.patch?full_index=1";
      hash = "sha256-zCeUWB3iuKqco030pULaRpRsIOpSRz9+VYxI/RQhIyw=";
    })
  ];

  build-system = [ flit-core ];

  dependencies = [
    flask
    sqlalchemy
  ]
  ++ flask.optional-dependencies.async
  ++ sqlalchemy.optional-dependencies.asyncio;

  pythonImportsCheck = [ "flask_sqlalchemy_lite" ];

  nativeCheckInputs = [
    aiosqlite
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pallets-eco/flask-sqlalchemy-lite/blob/${src.rev}/CHANGES.md";
    description = "Integrate SQLAlchemy with Flask";
    homepage = "https://github.com/pallets-eco/flask-sqlalchemy-lite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
