{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  pytest-runner,
  aiohttp,
  attrs,
  multidict,
  colorlog,
  pynacl,
  pytest-cov,
  pytest-randomly,
  pytest-asyncio,
  mock,
}:
buildPythonPackage rec {
  pname = "hikari";
  version = "2.0.0.dev125";

  src = fetchFromGitHub {
    owner = "hikari-py";
    repo = "hikari";
    rev = version;
    hash = "sha256-qxgIYquXUWrm8bS8EamERMHOnjI2aPyK7bQieVG66uA=";
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

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    multidict
    colorlog
  ];

  pythonRelaxDeps = true;

  passthru.optional-dependencies = {
    server = [ pynacl ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-runner
    pytest-asyncio
    pytest-cov
    pytest-randomly
    mock
  ];

  pythonImportChecks = [ "hikari" ];

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace hikari/_about.py --replace "__git_sha1__: typing.Final[str] = \"HEAD\"" "__git_sha1__: typing.Final[str] = \"$(cat $src/COMMIT)\""
  '';

  meta = with lib; {
    description = "Discord API wrapper for Python written with asyncio";
    homepage = "https://www.hikari-py.dev/";
    changelog = "https://github.com/hikari-py/hikari/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
