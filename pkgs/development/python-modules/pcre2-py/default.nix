{
  build,
  bzip2,
  cmake,
  cython,
  editline,
  gitpython,
  pytestCheckHook,
  buildPythonPackage,
  fetchFromGitHub,
  haskellPackages,
  lib,
  libedit,
  libz,
  pcre2,
  scikit-build,
  setuptools,
  twine,
  readline,
  requests,
}:

buildPythonPackage rec {
  pname = "pcre2-py";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grtetrault";
    repo = "pcre2.py";
    tag = "v${version}";
    hash = "sha256-W3oKluXC4orw1ThYM1Beeu8+6rNMr8FSCqep84SmXLE=";
    fetchSubmodules = false;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(src/libpcre2)" "" \
      --replace-fail "install" "#install"
    substituteInPlace src/pcre2/CMakeLists.txt \
      --replace-fail "\''${PCRE2_INCLUDE_DIR}" "${pcre2.dev}/include" \
      --replace-fail "pcre2-8-static" "pcre2-8"
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    cmake
    cython
    scikit-build
    setuptools
  ];

  dependencies = [
    haskellPackages.bz2
    haskellPackages.memfd
  ]
  ++ [
    build
    bzip2
    editline
    libedit
    libz
    pcre2
    readline
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    twine
    gitpython
  ];

  pythonImportsCheck = [ "pcre2" ];

  postCheck = ''
    cd $out
    rm -rf *.t* *.py requirements Makefile LICENSE *.md
  '';

  meta = {
    description = "Python bindings for the PCRE2 library created by Philip Hazel";
    homepage = "https://github.com/grtetrault/pcre2.py";
    changelog = "https://github.com/grtetrault/pcre2.py/releases/tag/v{version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
