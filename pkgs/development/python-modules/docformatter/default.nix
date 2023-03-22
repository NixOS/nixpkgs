{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, charset-normalizer
, tomli
, untokenize
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.5.1";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-r+8FOl9Rrfi3V8f8wD41bRsaqDb+UrOBWuR3goK43xY=";
  };

  patches = [
    ./test-path.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'charset_normalizer = "^2.0.0"' 'charset_normalizer = ">=2.0.0"'
    substituteInPlace tests/conftest.py \
      --subst-var-by docformatter $out/bin/docformatter
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    charset-normalizer
    tomli
    untokenize
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "docformatter" ];

  meta = {
    changelog = "https://github.com/PyCQA/docformatter/blob/${src.rev}/CHANGELOG.md";
    description = "Formats docstrings to follow PEP 257";
    homepage = "https://github.com/myint/docformatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
