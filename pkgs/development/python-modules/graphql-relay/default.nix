{ lib
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, poetry-core
, pytest-asyncio
, pytest-describe
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "graphql-relay";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-relay-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-Fji5/Yb/nogGvIFeBXs9Plt7QXI2mFnGtQMjaT36mPU=";
  };

  # This project doesn't seem to actually need setuptools. To find out why it
  # specifies it, follow up in:
  #
  #   https://github.com/graphql-python/graphql-relay-py/issues/49
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools>=59,<70"' ""
  '';

  pythonRemoveDeps = [
    "graphql-core"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    graphql-core
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-describe
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphql_relay"
  ];

  meta = with lib; {
    description = "Library to help construct a graphql-py server supporting react-relay";
    homepage = "https://github.com/graphql-python/graphql-relay-py/";
    changelog = "https://github.com/graphql-python/graphql-relay-py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
