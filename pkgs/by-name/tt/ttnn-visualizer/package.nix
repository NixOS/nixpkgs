{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs_24,
  pnpmConfigHook,
  pnpm_11,
  python3,
  stdenvNoCC,
  writeShellScriptBin,
}:

let
  version = "0.110.0";

  patchNodeEngine = ''
    substituteInPlace package.json \
      --replace-fail '"node": "24.22.1"' '"node": ">=24.22.1"'
    substituteInPlace pnpm-workspace.yaml \
      --replace-fail 'engineStrict: true' 'engineStrict: false'
  '';

  ps = python3.pkgs;
  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "ttnn-visualizer";
    tag = "v${version}";
    hash = "sha256-MLKLdXHmcnF8LmzZUb4FuaRGj9mFw6lHhrFEVhzWFo8=";
  };

  frontendSource = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ttnn-visualizer-frontend-source";
    inherit version;
    inherit src;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) src pname version;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-lVFVvi/ORiCbYOzuAczUkLyrsUFyo6cfpv6tjaAWBMc=";
      postPatch = patchNodeEngine;
    };

    nativeBuildInputs = [
      nodejs_24
      pnpm_11
      pnpmConfigHook
    ];

    env = {
      CI = "true";
      npm_config_yes = "true";
      pnpm_config_confirm_modules_purge = "false";
    };

    postPatch = ''
      ${patchNodeEngine}

      ${python3}/bin/python - <<'PY'
      import json
      from pathlib import Path

      package_json = Path("package.json")
      data = json.loads(package_json.read_text())
      scripts = data.get("scripts", {})
      scripts.pop("prepare", None)
      data["scripts"] = scripts
      package_json.write_text(json.dumps(data, indent=2) + "\n")
      PY
    '';

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r . "$out/"
      runHook postInstall
    '';
  });

  ttnnVisualizer = ps.buildPythonPackage (finalAttrs: {
    pname = "ttnn-visualizer";
    inherit version;
    pyproject = true;
    src = frontendSource;

    build-system = [
      ps.setuptools
      ps.wheel
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'setuptools>=78.1.1,<81.0' 'setuptools'
    '';

    propagatedBuildInputs = [
      ps.alembic
      ps.build
      ps.flask
      ps.flask-cors
      ps.flask-socketio
      ps.flask-sqlalchemy
      ps.flask-static-digest
      ps.gevent
      ps.gunicorn
      ps.orjson
      ps.pandas
      ps.pydantic
      ps.pydantic-core
      ps.python-dotenv
      ps.pyyaml
      ps.tt-perf-report
      ps.uvicorn
      ps.zstd
    ];

    pythonRelaxDeps = [
      "alembic"
      "flask-cors"
      "flask-socketio"
      "flask"
      "gevent"
      "gunicorn"
      "pandas"
      "pydantic-core"
      "pydantic"
      "python-dotenv"
      "pyyaml"
      "setuptools"
      "tt-perf-report"
      "uvicorn"
      "zstd"
    ];

    pythonImportsCheck = [ "ttnn_visualizer" ];
  });

  pythonEnv = python3.withPackages (ps: [
    ttnnVisualizer
    ps.gunicorn
    ps.gevent
  ]);
in
(writeShellScriptBin "ttnn-visualizer" ''
  export FLASK_ENV=production
  export PATH="${lib.makeBinPath [ pythonEnv ]}:$PATH"
  exec ${pythonEnv}/bin/python -m ttnn_visualizer.app "$@"
'').overrideAttrs
  (_: {
    strictDeps = true;
    __structuredAttrs = true;
    meta = {
      description = "Tool for visualizing and analyzing TT-NN model execution";
      homepage = "https://github.com/tenstorrent/ttnn-visualizer";
      license = lib.licenses.asl20;
      mainProgram = "ttnn-visualizer";
      maintainers = with lib.maintainers; [ mert-kurttutan ];
      platforms = lib.platforms.linux;
    };
  })
