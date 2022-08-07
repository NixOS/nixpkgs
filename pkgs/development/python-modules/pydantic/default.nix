{ lib
, stdenv
, buildPythonPackage
, cython
, devtools
, email-validator
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, python-dotenv
, pythonOlder
, typing-extensions
# dependencies for building documentation.
# docs fail to build in Darwin sandbox: https://github.com/samuelcolvin/pydantic/issues/4245
, withDocs ? (stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.isDarwin)
, ansi2html
, markdown-include
, mkdocs
, mkdocs-exclude
, mkdocs-material
, mdx-truly-sane-lists
, sqlalchemy
, ujson
, orjson
, hypothesis
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.9.1";

  outputs = [
    "out"
  ] ++ lib.optionals withDocs [
    "doc"
  ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jqTtNJQ9lRkxDYGG4vg91qH1jrxRU9orEeUofO+bBpA=";
  };

  postPatch = ''
    sed -i '/flake8/ d' Makefile
  '';

  nativeBuildInputs = [
    cython
  ] ++ lib.optionals withDocs [
    # dependencies for building documentation
    ansi2html
    markdown-include
    mdx-truly-sane-lists
    mkdocs
    mkdocs-exclude
    mkdocs-material
    sqlalchemy
    ujson
    orjson
    hypothesis
  ];

  propagatedBuildInputs = [
    devtools
    email-validator
    python-dotenv
    typing-extensions
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Must include current directory into PYTHONPATH, since documentation
  # building process expects "import pydantic" to work.
  preBuild = lib.optionalString withDocs ''
    PYTHONPATH=$PWD:$PYTHONPATH make docs
  '';

  # Layout documentation in same way as "sphinxHook" does.
  postInstall = lib.optionalString withDocs ''
    mkdir -p $out/share/doc/$name
    mv ./site $out/share/doc/$name/html
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    homepage = "https://github.com/samuelcolvin/pydantic";
    description = "Data validation and settings management using Python type hinting";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
