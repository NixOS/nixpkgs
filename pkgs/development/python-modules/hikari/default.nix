{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  aiohttp,
  attrs,
  multidict,
  colorlog,
  pynacl,
  pytest-cov-stub,
  pytest-randomly,
  pytest-asyncio,
  mock,
}:
buildPythonPackage rec {
  pname = "hikari";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hikari-py";
    repo = "hikari";
    tag = version;
    hash = "sha256-lkJICN5uXFIKUZwxZI82FSYZLWFa7Cb6tDs6wV9DsY0=";
    # The git commit is part of the `hikari.__git_sha1__` original output;
    # leave that output the same in nixpkgs. Use the `.git` directory
    # to retrieve the commit SHA, and remove the directory afterwards,
    # since it is not needed after that.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    multidict
    colorlog
  ];

  pythonRelaxDeps = true;

  optional-dependencies = {
    server = [ pynacl ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-randomly
    mock
  ];

  pythonImportsCheck = [ "hikari" ];

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace hikari/_about.py \
      --replace-fail "__git_sha1__: typing.Final[str] = \"HEAD\"" "__git_sha1__: typing.Final[str] = \"$(cat $src/COMMIT)\""
    # XXX: Remove once pytest-asyncio is updated to 0.24+
    substituteInPlace pyproject.toml \
      --replace-fail "asyncio_default_fixture_loop_scope = \"func\"" ""
  '';

  meta = {
    description = "Discord API wrapper for Python written with asyncio";
    homepage = "https://www.hikari-py.dev/";
    changelog = "https://github.com/hikari-py/hikari/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tomodachi94
      sigmanificient
    ];
  };
}
