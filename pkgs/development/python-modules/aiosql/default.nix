{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "aiosql";
  version = "9.0";
  outputs = [ "out" "doc" ];
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nackjicholson";
    repo = "aiosql";
    rev = "refs/tags/${version}";
    hash = "sha256-AwuZ3y/qAyZzffTG6mHLk0b+zFB9307VjAX8g1pvWto=";
  };

  sphinxRoot = "docs/source";

  nativeBuildInputs = [
    pytestCheckHook
    sphinxHook
    poetry-core
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [ "aiosql" ];

  meta = with lib; {
    description = "Simple SQL in Python";
    homepage = "https://nackjicholson.github.io/aiosql/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ kaction ];
  };
}
