{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown-it-py
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-markdown-docs";
  version = "ccbf991a9a0b1cdb78eaf51e0b0d8e6f32faaf49";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "modal-labs";
    repo = "pytest-markdown-docs";
    # most recent release requires old version of markdown-it-py, so using commit
    # rev = "/refs/tags/v${version}";
    rev = version;
    hash = "sha256-p86Oekdj4glW3U2samL7o8pz5Uma/LcDFvRvN5UhGzc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    poetry-dynamic-versioning
    markdown-it-py
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/modal-labs/pytest-markdown-docs";
    description = "Run markdown code fences through pytest.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexkireeff ];
  };
}
