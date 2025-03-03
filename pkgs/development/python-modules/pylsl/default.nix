{
  lib,
  liblsl,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pylsl";
  version = "1.17.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labstreaminglayer";
    repo = "pylsl";
    tag = "v${version}";
    hash = "sha256-PEeTG+bQNEce9j0obDoaTYXMGp0MRUibbWVXM1IvGGY=";
  };

  postPatch = ''
    substituteInPlace pylsl/pylsl.py \
      --replace "def find_liblsl_libraries(verbose=False):" "$(echo -e "def find_liblsl_libraries(verbose=False):\n    yield '${liblsl}/lib/liblsl.so'")"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildImputs = [ liblsl ];

  pythonImportsCheck = [ "pylsl" ];

  meta = with lib; {
    description = "Python bindings (pylsl) for liblsl";
    homepage = "https://github.com/labstreaminglayer/pylsl";
    license = licenses.mit;
    maintainers = with maintainers; [ abcsds ];
    mainProgram = "pylsl";
  };
}
