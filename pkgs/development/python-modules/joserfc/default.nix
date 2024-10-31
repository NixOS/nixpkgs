{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  pycryptodome,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "joserfc";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authlib";
    repo = "joserfc";
    rev = "refs/tags/${version}";
    hash = "sha256-mnJzhkdX0+5Y/XwGlHgxLP0me8Cs/Cl3p46KgTKw2ug=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  optional-dependencies = {
    drafts = [ pycryptodome ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "joserfc" ];

  meta = with lib; {
    description = "Implementations of JOSE RFCs in Python";
    homepage = "https://github.com/authlib/joserfc";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
