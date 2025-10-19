{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
}:

buildPythonPackage rec {
  pname = "mdformat-footnote";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-footnote";
    tag = "v${version}";
    hash = "sha256-JVxztVcp60LynacPw8tBrmSfe6Ool8zyK+aYwaKhyiA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  pythonImportsCheck = [ "mdformat_footnote" ];

  meta = with lib; {
    description = "Footnote format addition for mdformat";
    homepage = "https://github.com/executablebooks/mdformat-footnote";
    changelog = "https://github.com/executablebooks/mdformat-footnote/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
