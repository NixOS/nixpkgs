{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, python
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "funcparserlib";
  version = "1.0.0a0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vlasovskikh";
    repo = pname;
    rev = version;
    sha256 = "sha256-YfcboKjyc5ASzrp0duu2R6psf51MGZIeZ0owo5QNSnU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    six
  ];

  patches = [
    # Support for poetry-core, https://github.com/vlasovskikh/funcparserlib/pull/73
    (fetchpatch {
      name = "support-poetry-core.patch";
      url = "https://github.com/vlasovskikh/funcparserlib/commit/61ed558fc146b7a30879919325dfa8aae77be556.patch";
      sha256 = "sha256-tqdR3r4/t7RWBYZeAabaN7oYf6VxkVVz006XICX9rYI=";
    })
  ];

  pythonImportsCheck = [
    "funcparserlib"
  ];

  meta = with lib; {
    description = "Recursive descent parsing library based on functional combinators";
    homepage = "https://github.com/vlasovskikh/funcparserlib";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
