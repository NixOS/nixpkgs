{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, natsort
, typing-extensions
, pytz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "domdf-python-tools";
  version = "3.8.0.post2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "domdf_python_tools";
    rev = "v${version}";
    hash = "sha256-dghuxm7PCX7f2DAMH0SB5znbqKVD/I+GSWqrEeS6bRM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
    natsort
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
    dates = [
      pytz
    ];
  };

  pythonImportsCheck = [ "domdf_python_tools" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Helpful functions for Python";
    homepage = "https://github.com/domdfcoding/domdf_python_tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
