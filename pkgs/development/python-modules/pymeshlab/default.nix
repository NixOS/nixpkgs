{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  python,

  # nativeBuildInputs
  cmake,
  pybind11,

  # propagatedBuildInputs
  meshlab,
  numpy,

  # buildInputs
  libsForQt5,
  llvmPackages,
  glew,
  vcg,
}:

let
  version = "2025.7.post1";
in
buildPythonPackage {
  inherit version;
  pname = "pymeshlab";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "pymeshlab";
    tag = "v${version}";
    hash = "sha256-TfnPdnq1rBx+spRw966jwyKxgXSlISLmacXQbvKU+OI=";
  };

  patches = [
    # CMake: allow use of system-provided meshlab & pybind11
    # ref. https://github.com/cnr-isti-vclab/PyMeshLab/pull/445
    # merged upstream
    (fetchpatch {
      url = "https://github.com/cnr-isti-vclab/PyMeshLab/commit/b363caae4362746b3f9e9326fe7b72a2ec7824d9.patch";
      hash = "sha256-euKfOx/T0qdeMx79dpEalzmdWsr4nbDFJfKdksvULBw=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  propagatedBuildInputs = [
    meshlab
    numpy
  ];

  buildInputs = [
    glew
    libsForQt5.qtbase
    vcg
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python.sitePackages}/pymeshlab"
  ];

  # Get io & filter plugins from meshlab, to avoild render, decorate & edit ones
  postInstall =
    let
      plugins =
        if stdenv.hostPlatform.isDarwin then
          "Applications/meshlab.app/Contents/PlugIns"
        else
          "lib/meshlab/plugins";
      pyPlugins = if stdenv.hostPlatform.isDarwin then "PlugIns" else "lib/plugins";
    in
    ''
      install -D -t $out/${python.sitePackages}/pymeshlab/${pyPlugins} \
        ${meshlab}/${plugins}/libio_* \
        ${meshlab}/${plugins}/libfilter_*
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --add-needed ${meshlab}/lib/meshlab/libmeshlab-common.so \
      $out/${python.sitePackages}/pymeshlab/pmeshlab.*.so
  '';

  pythonImportsCheck = [ "pymeshlab" ];

  meta = {
    description = "Open source mesh processing python library";
    homepage = "https://github.com/cnr-isti-vclab/PyMeshLab";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
