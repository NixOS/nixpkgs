{ buildPythonPackage
, fetchFromGitHub
, lib
, future
, gcc
, llvmlite
, parameterized
, pycparser
, pyparsing
, z3-solver
, setuptools
}:
let
  commit = "90dc1671b59077ee27c3d44d9d536d6659eb3bbe";
in
buildPythonPackage rec {
  pname = "miasm";
  version = "0.1.5-unstable-2024-04-28";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "cea-sec";
    repo = "miasm";
    rev = commit;
    hash = "sha256-nkRcirJLmTwSL7lwd+Yk6mteU3YPnm5ekJ4eFF5FmYo=";
  };

  patches = [
    #  Use a valid semver as now required by setuptools
    ./0001-setup.py-use-valid-semver.patch

    # Removes the (unfree) IDAPython dependency
    ./0002-core-remove-IDAPython-dependency.patch
  ];

  dependencies = [
    future
    llvmlite
    parameterized
    pycparser
    pyparsing
    z3-solver
  ];

  buildInputs = [ gcc ];

  pythonImportsCheck = [ "miasm" ];

  meta = {
    description = "Reverse engineering framework in Python";
    homepage = "https://github.com/cea-sec/miasm";
    changelog = "https://github.com/cea-sec/miasm/blob/${commit}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ msanft ];
  };
}
