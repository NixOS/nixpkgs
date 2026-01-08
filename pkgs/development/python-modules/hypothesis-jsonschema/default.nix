{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonschema,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage {
  pname = "hypothesis-jsonschema";
  version = "0.23.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "hypothesis-jsonschema";
    rev = "fa38b03d8bb6f917ba749ef84ce1e4465d1e27cc";
    hash = "sha256-gZH+3PaoDE+l6Q/aXG9PzjzsqG5oCmZlTVGtl5HPc4w=";
  };

  dependencies = [
    hypothesis
    jsonschema
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  # tox.ini has pytest coverage flags that require pytest-cov; remove it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlags = [
    # some hypothesis-jsonschema tests depend on -Werror turning warnings into
    # errors. In the repo itself, this is set by tox.ini, which we removed above.
    "-Werror"
  ];

  pythonImportsCheck = [ "hypothesis_jsonschema" ];

  meta = {
    description = "Generate test data from JSON schemata with Hypothesis";
    homepage = "https://github.com/python-jsonschema/hypothesis-jsonschema";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.liamdevoe
    ];
  };
}
