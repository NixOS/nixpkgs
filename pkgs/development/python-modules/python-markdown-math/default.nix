{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  markdown,
}:

buildPythonPackage rec {
  pname = "python-markdown-math";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitya57";
    repo = "python-markdown-math";
    tag = version;
    hash = "sha256-m/i43lvOehZSazHXhoAZTRSB5BQgn2VFjXADxSKeXfs=";
  };

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  meta = {
    description = "Math extension for Python-Markdown";
    homepage = "https://github.com/mitya57/python-markdown-math";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
