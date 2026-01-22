{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mscerts";
  version = "2025.8.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    tag = version;
    hash = "sha256-K7U4dbhH3yWElSKRhU9mHU4W+Hdc6Vb9kf/TE4EJs8c=";
  };

  build-system = [ setuptools ];

  # extras_require contains signify -> circular dependency

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "mscerts" ];

  meta = {
    description = "Makes the Microsoft Trusted Root Program's Certificate Trust Lists available in Python";
    homepage = "https://github.com/ralphje/mscerts";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
