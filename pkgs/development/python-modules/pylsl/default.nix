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
  version = "1.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labstreaminglayer";
    repo = "pylsl";
    rev = "v${version}";
    hash = "sha256-rReoPirf1rdQppKEBfHMk3J2htdsnFfIdlNQIprOoUg=";
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
