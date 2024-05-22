{ lib
, buildPythonPackage
, fetchFromGitHub
, whey
, pygments
, typing-extensions
, sphinx
#, sphinx-jinja2-compat
#, sphinx-toolbox
, beautifulsoup4
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "enum-tools";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "enum_tools";
    rev = "v${version}";
    hash = "sha256-D5xMIcryOCtydfgNkEDFhsBSzbIuozGd5bZls9DAwaE=";
  };

  build-system = [
    whey
  ];

  dependencies = [
    pygments
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
    sphinx = [
      sphinx
      #sphinx-jinja2-compat
      #sphinx-toolbox
    ];
  };

  pythonImportsCheck = [ "enum_tools" ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
    sphinx
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Tools to expand Python's enum module";
    homepage = "https://github.com/domdfcoding/enum_tools";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
