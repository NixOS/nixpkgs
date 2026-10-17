{
  lib,
  blas,
  lapack,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  stdenv,
}:

buildPythonPackage {
  pname = "prox-tv";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albarji";
    repo = "proxTV";
    rev = "e621585d5aaa7983fbee68583f7deae995d3bafb";
    hash = "sha256-BR8x1m6GxDL007cfnzSWZk6t69Vr5Cnja+jwXNaSmVY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    cffi
  ];

  buildInputs = [
    blas
    lapack
  ];

  propagatedNativeBuildInputs = [ cffi ];

  enableParallelBuilding = true;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_tvp_1d" ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_tv2_1d" ];

  meta = {
    homepage = "https://github.com/albarji/proxTV";
    description = "Toolbox for fast Total Variation proximity operators";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ multun ];
  };
}
