{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  sortedcollections,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jab";
    repo = "bidict";
    tag = "v${version}";
    hash = "sha256-usY8oJoU72IXS1Um46Eir1aHGjZRuwipHAQ6uACyJEg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.13,<0.12" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-xdist
    pytestCheckHook
    sortedcollections
    typing-extensions
  ];

  pythonImportsCheck = [ "bidict" ];

  meta = {
    homepage = "https://github.com/jab/bidict";
    changelog = "https://github.com/jab/bidict/blob/main/CHANGELOG.rst";
    description = "Bidirectional mapping library for Python";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      jab
      jakewaksbaum
    ];
  };
}
