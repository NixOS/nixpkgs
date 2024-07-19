{
  lib,
  buildPythonApplication,
  buildPythonPackage,
  fetchFromGitHub,
  makeWrapper,
  pytestCheckHook,
  python,
  pythonOlder,
  ruff,
  setuptools,
  click-default-group,
  numpy,
  openai,
  pip,
  pluggy,
  pydantic,
  python-ulid,
  pyyaml,
  sqlite-migrate,
  cogapp,
  pytest-httpx,
  sqlite-utils,
}:
let
  llm = buildPythonPackage rec {
    pname = "llm";
    version = "0.14";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "simonw";
      repo = "llm";
      rev = "refs/tags/${version}";
      hash = "sha256-CgGVFUsntVkF0zORAtYQQMAeGtIwBbj9hE0Ei1OCGq4=";
    };

    patches = [ ./001-disable-install-uninstall-commands.patch ];

    nativeBuildInputs = [ setuptools ];

    propagatedBuildInputs = [
      click-default-group
      numpy
      openai
      pip
      pluggy
      pydantic
      python-ulid
      pyyaml
      setuptools # for pkg_resources
      sqlite-migrate
      sqlite-utils
    ];

    nativeCheckInputs = [
      cogapp
      numpy
      pytest-httpx
      pytestCheckHook
    ];

    doCheck = true;

    pytestFlagsArray = [
      "-svv"
      "tests/"
    ];

    pythonImportsCheck = [ "llm" ];

    passthru = {
      inherit withPlugins;
    };

    meta = with lib; {
      homepage = "https://github.com/simonw/llm";
      description = "Access large language models from the command-line";
      changelog = "https://github.com/simonw/llm/releases/tag/${version}";
      license = licenses.asl20;
      mainProgram = "llm";
      maintainers = with maintainers; [ aldoborrero ];
    };
  };

  withPlugins =
    plugins:
    buildPythonApplication {
      inherit (llm) pname version;
      format = "other";

      disabled = pythonOlder "3.8";

      dontUnpack = true;
      dontBuild = true;
      doCheck = false;

      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        makeWrapper ${llm}/bin/llm $out/bin/llm \
          --prefix PYTHONPATH : "${llm}/${python.sitePackages}:$PYTHONPATH"
        ln -sfv ${llm}/lib $out/lib
      '';

      propagatedBuildInputs = llm.propagatedBuildInputs ++ plugins;

      passthru = llm.passthru // {
        withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
      };

      inherit (llm) meta;
    };
in
llm
