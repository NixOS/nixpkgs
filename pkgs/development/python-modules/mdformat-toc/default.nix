{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mdformat,
  mdit-py-plugins,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-toc";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3EX6kGez408tEYiR9VSvi3GTrb4ds+HJwpFflv77nkg=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ mdformat ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_toc" ];

  meta = with lib; {
    description = "Mdformat plugin to generate a table of contents";
    homepage = "https://github.com/hukkin/mdformat-toc";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      polarmutex
    ];
  };
}
