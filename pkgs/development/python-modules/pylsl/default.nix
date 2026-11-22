{
  lib,
  liblsl,
  fetchFromGitHub,
  buildPythonPackage,
  stdenv,
  numpy,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "pylsl";
  version = "1.18.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labstreaminglayer";
    repo = "pylsl";
    tag = "v${version}";
    hash = "sha256-GTuEVjegimwbKAgoVgC44NhvUjQcjVmPTNBh13i1ejE=";
  };

  postPatch = ''
    substituteInPlace src/pylsl/lib/__init__.py \
      --replace "def find_liblsl_libraries(verbose=False):" "$(echo -e "def find_liblsl_libraries(verbose=False):\n    yield '${liblsl}/lib/liblsl.${
        if stdenv.hostPlatform.isDarwin then "dylib" else "so"
      }'")"
  '';

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    liblsl
    numpy
  ];

  pythonImportsCheck = [ "pylsl" ];

  meta = {
    description = "Python bindings (pylsl) for liblsl";
    homepage = "https://github.com/labstreaminglayer/pylsl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abcsds ];
  };
}
