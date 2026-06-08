{
  lib,
  fetchFromGitHub,
  fetchPypi,
  fetchPnpmDeps,
  nodejs_24,
  pnpmConfigHook,
  pnpm_11,
  python3,
  stdenvNoCC,
  writeShellScriptBin,
}:

let
  version = "0.88.0";

  python = python3.override {
    packageOverrides = final: prev: {
      flask-static-digest = final.buildPythonPackage rec {
        pname = "flask-static-digest";
        version = "0.4.1";
        pyproject = true;

        src = fetchPypi {
          pname = "flask_static_digest";
          inherit version;
          hash = "sha256-prOOlTpM+qwJLgrkD+6oKk8Ji/rFCWnO/EjUqedJLhQ=";
        };

        build-system = [
          final.setuptools
          final.wheel
        ];

        dependencies = [ final.flask ];

        pythonImportsCheck = [ "flask_static_digest" ];
      };

      tt-perf-report = final.buildPythonPackage rec {
        pname = "tt-perf-report";
        version = "1.2.4";
        pyproject = true;

        src = fetchPypi {
          pname = "tt_perf_report";
          inherit version;
          hash = "sha256-88KxPIus4l073KM6z6LIiC9ee6ohnbKV6yPD9Yjep8k=";
        };

        build-system = [
          final.setuptools
          final.wheel
        ];

        dependencies = [
          final.pandas
          final.matplotlib
        ];

        pythonImportsCheck = [ "tt_perf_report" ];
      };
    };
  };
  ps = python.pkgs;
  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "ttnn-visualizer";
    tag = "v${version}";
    hash = "sha256-9ohL+xjiu56gasor8+eKsJPWhoDVD1zxFw60QYbWsHQ=";
  };

  frontendSource = stdenvNoCC.mkDerivation {
    pname = "ttnn-visualizer-frontend-source";
    inherit version;
    inherit src;

    pnpmDeps = fetchPnpmDeps {
      inherit src;
      pname = "ttnn-visualizer";
      inherit version;
      pnpm = pnpm_11;
      fetcherVersion = 3;
      hash = "sha256-hsNslFQE46H07q42cqATx2z6TApSU0uhaz6FVtLgPB8=";
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
  };

  ttnnVisualizer = ps.buildPythonPackage {
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
        --replace-fail 'setuptools==78.1.1' 'setuptools>=78.1.1,<81.0'
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
      "flask-cors"
      "flask-socketio"
      "flask"
      "pandas"
      "pyyaml"
      "uvicorn"
      "zstd"
    ];

    pythonImportsCheck = [ "ttnn_visualizer" ];
  };

  pythonEnv = python.withPackages (ps: [
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
