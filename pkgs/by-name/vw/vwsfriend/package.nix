{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vwsfriend";
  version = "0.24.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "VWsFriend";
    rev = "refs/tags/v${version}";
    hash = "sha256-bKL0ExHV/wz3qwB5pMgZDkASr93sCUb01uTipkE5iJU=";
  };

  sourceRoot = "${src.name}/vwsfriend";

  postPatch = ''
    # we don't need pytest-runner, pylint, etc.
    true > setup_requirements.txt

    substituteInPlace requirements.txt \
      --replace-fail psycopg2-binary psycopg2
  '';

  build-system = with python3.pkgs; [ setuptools ];

  pythonRelaxDeps = true;

  dependencies =
    with python3.pkgs;
    [
      weconnect
      hap-python
      pypng
      sqlalchemy
      psycopg2
      requests
      werkzeug
      flask
      flask-login
      flask-caching
      wtforms
      flask-wtf
      flask-sqlalchemy
      alembic
      haversine
    ]
    ++ weconnect.optional-dependencies.Images
    ++ hap-python.optional-dependencies.QRCode;

  meta = {
    changelog = "https://github.com/tillsteinbach/VWsFriend/blob/${src.rev}/CHANGELOG.md";
    description = "VW WeConnect visualization and control";
    homepage = "https://github.com/tillsteinbach/VWsFriend";
    license = lib.licenses.mit;
    mainProgram = "vwsfriend";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
