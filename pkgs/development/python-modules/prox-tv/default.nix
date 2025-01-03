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
    sha256 = "0mlrjbb5rw78dgijkr3bspmsskk6jqs9y7xpsgs35i46dvb327q5";
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

  disabledTests = [ "test_tvp_1d" ] ++ lib.optionals stdenv.isDarwin [ "test_tv2_1d" ];

  meta = with lib; {
    homepage = "https://github.com/albarji/proxTV";
    description = "Toolbox for fast Total Variation proximity operators";
    license = licenses.bsd2;
    maintainers = with maintainers; [ multun ];
  };
}
