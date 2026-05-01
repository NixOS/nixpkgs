{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  cmake,
  ninja,
  stdenv,
  llvmPackages,
  boost,
  python,
}:

buildPythonPackage rec {
  pname = "opencamlib";
  version = "2023.01.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aewallin";
    repo = "opencamlib";
    tag = version;
    hash = "sha256-pUj71PdWo902dqF9O6SLnpvFooFU2OfLBv8hAVsH/iA=";
  };

  build-system = [
    scikit-build-core
  ];

  buildInputs = [
    boost
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "2022.12.18"' 'version = "${version}"'
  '';

  dontUseCmakeConfigure = true;
  env.CMAKE_ARGS = "-DVERSION_STRING=${version} -DBoost_USE_STATIC_LIBS=OFF";

  pythonImportsCheck = [ "opencamlib" ];

  checkPhase = ''
    runHook preCheck

    pushd examples/python
    # this produces a lot of non-actionalble lines on stdout
    ${python.interpreter} test.py > /dev/null
    popd

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/aewallin/opencamlib";
    description = "Open source computer aided manufacturing algorithms library";
    # from src/deb/debian_copyright.txt
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ tomjnixon ];
  };
}
