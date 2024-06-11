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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authlib";
    repo = "joserfc";
    rev = version;
    hash = "sha256-+NFCveMPzE0hSs2Qe20/MDHApXVtU3cR/GPFKPqfVV4=";
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
    maintainers = with maintainers; [ ];
  };
}
