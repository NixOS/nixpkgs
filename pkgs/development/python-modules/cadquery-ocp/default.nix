{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  isPy3k,
  python,

  # build
  cmake,
  mpi,
  pybind11,

  # dependencies
  fontconfig,
  freeglut,
  libGLU,
  opencascade-occt,
  rapidjson,
  vtk,
}:
buildPythonPackage (finalAttrs: {
  pname = "cadquery-ocp";
  version = "7.8.1.2";
  pyproject = false;
  disabled = !isPy3k;

  # While I would prefer to codegen this from source, the toolchain is truly hideous and I have
  # already spent several days trying to get it to work. For now, we use the pre-generated stubs.
  src = fetchzip {
    # 7.9.3.0 uses "Linux" instead of "ubuntu-20.04" in the release name, so the next update will
    # require updating more than the version.
    url = "https://github.com/CadQuery/OCP/releases/download/${finalAttrs.version}/OCP_src_stubs_ubuntu-20.04.zip";
    hash = "sha256-sg6QEZWNvY9xz5RNA2/bImYI5PpvOyndBKrlNfZgsUI=";
    stripRoot = true;
  };

  nativeBuildInputs = [
    cmake
    mpi
    pybind11
  ];

  buildInputs = [
    fontconfig
    freeglut
    libGLU
    ((opencascade-occt.override { withVtk = true; }).overrideAttrs {
      version = "7.8.1";
      src = fetchFromGitHub {
        owner = "Open-Cascade-SAS";
        repo = "OCCT";
        rev = "V7_8_1";
        sha256 = "sha256-tg71cFx9HZ471T/3No9CeEHi8VSo0ZITIuNfTSNB2qU=";
      };
    })
    rapidjson
    vtk
  ];

  installPhase = ''
    runHook preInstall

    install -D *.so -t $out/${python.sitePackages}

    runHook postInstall
  '';

  pythonImportsCheck = [ "OCP" ];

  meta = {
    description = "Python wrapper for OpenCASCADE generated using pywrap (CadQuery OCP)";
    homepage = "https://github.com/CadQuery/OCP";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
