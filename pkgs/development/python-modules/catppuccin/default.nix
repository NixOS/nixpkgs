{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pygments
, rich
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "catppuccin";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "python";
    rev = "v${version}";
    hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  passthru.optional-dependencies = {
    pygments = [ pygments ];
    rich = [ rich ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_flavour.py" # would download a json to check correctness of flavours
  ];

  pythonImportsCheck = [ "catppuccin" ];

  meta = {
    description = "Soothing pastel theme for Python";
    homepage = "https://github.com/catppuccin/python";
    maintainers = with lib.maintainers; [ fufexan tomasajt ];
    license = lib.licenses.mit;
  };
}
