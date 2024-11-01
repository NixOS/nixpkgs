{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "hikari-py";
    repo = "hikari";
    rev = "refs/tags/${version}";
    hash = "sha256-/A3D3nG1lSCQU92dM+6YroxWlGKrv47ntkZaJZTAJUA=";
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
  '';

  meta = {
    description = "Discord API wrapper for Python written with asyncio";
    homepage = "https://www.hikari-py.dev/";
    changelog = "https://github.com/hikari-py/hikari/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 sigmanificient ];
  };
}
