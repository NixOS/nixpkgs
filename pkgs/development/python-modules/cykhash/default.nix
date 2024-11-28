{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  cython,
  setuptools,
  numpy,

  distutils,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "cykhash";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "realead";
    repo = "cykhash";
    rev = "fdecec42188eb8610e17b9920852eeedb3948aaf";
    hash = "sha256-71a8GuaoIMxC7VMnWWoowmo+WLZIzULQzXUm7tHL2II=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "cykhash" ];

  preCheck = ''
    cd tests/unit_tests
    export HOME=$TMPDIR
  '';

  nativeCheckInputs =
    [
      pytestCheckHook
      numpy
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # distutils tests do not work on darwin
      (distutils.overridePythonAttrs { doCheck = !stdenv.hostPlatform.isDarwin; })
    ];

  meta = {
    description = "Cython wrapper for khash";
    homepage = "https://github.com/realead/cykhash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
