{
  lib,
  buildPythonPackage,
  cython,
  fetchzip,
  keyutils,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "keyutils";
  version = "0.6";
  format = "setuptools";

  # github version comes bundled with tests
  src = fetchzip {
    url = "http://deb.debian.org/debian/pool/main/p/python-keyutils/python-keyutils_0.6.orig.tar.gz";
    hash = "sha256-/oL510Qi6ryugCuqx8/jPQGYlhGKDlMY54+2a9NTM88=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  preBuild = ''
    cython keyutils/_keyutils.pyx
  '';

  preCheck = ''
    rm -rf keyutils
  '';

  buildInputs = [ keyutils ];
  nativeBuildInputs = [ cython ];
  nativeCheckInputs = [ ];

  meta = {
    description = "Set of python bindings for keyutils";
    homepage = "https://github.com/sassoftware/python-keyutils";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
