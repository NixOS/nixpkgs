{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  libX11,
  libXt,
  libGL,
  openimageio,
  imath,
  python,
}:

buildPythonPackage rec {
  pname = "materialx";
  version = "1.39.4";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    rev = "v${version}";
    hash = "sha256-XNfXOC76zM5Ns2DyyE3mKCJ1iJaszs1M0rBdVLRDo8E=";
  };

  format = "other";

  nativeBuildInputs = [
    cmake
    setuptools
  ];

  buildInputs = [
    openimageio
    imath
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libX11
    libXt
    libGL
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    (lib.cmakeBool "MATERIALX_BUILD_OIIO" true)
    (lib.cmakeBool "MATERIALX_BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "MATERIALX_BUILD_PYTHON" true)
    (lib.cmakeBool "MATERIALX_BUILD_GEN_MSL" (
      stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin
    ))
  ];

  pythonImportsCheck = [ "MaterialX" ];

  postInstall = ''
    # Make python lib properly accessible
    target_dir=$out/${python.sitePackages}
    mkdir -p $(dirname $target_dir)
    # required for cmake to find the bindings, when included in other projects
    ln -s $out/python $target_dir
  '';

  meta = {
    changelog = "https://github.com/AcademySoftwareFoundation/MaterialX/blob/${src.rev}/CHANGELOG.md";
    description = "Open standard for representing rich material and look-development content in computer graphics";
    homepage = "https://materialx.org";
    maintainers = [ lib.maintainers.gador ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
  };
}
