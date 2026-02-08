{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "xcat";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "orf";
    repo = "xcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GkQwUvHl4pGvZtgq2tqCz6dOj4gMzAtVbhLv9lBKJQc=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiodns
    aiohttp
    appdirs
    click
    colorama
    faust-cchardet
    prompt-toolkit
    xpath-expressions
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "xcat" ];

  meta = {
    description = "XPath injection tool";
    longDescription = ''
      xcat is an advanced tool for exploiting XPath injection vulnerabilities,
      featuring a comprehensive set of features to read the entire file being
      queried as well as other files on the filesystem, environment variables
      and directories.
    '';
    homepage = "https://github.com/orf/xcat";
    changelog = "https://github.com/orf/xcat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xcat";
  };
})
