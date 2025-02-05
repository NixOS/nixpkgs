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
  apple-sdk_14,
}:

buildPythonPackage rec {
  pname = "materialx";
  version = "1.39.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    tag = "v${version}";
    hash = "sha256-WzzsY1hOWwJEqT/ZRLIoZDfKNvx1Yf6aFhA3ZcSPx+s=";
  };

  format = "other";

  nativeBuildInputs = [
    cmake
    setuptools
  ];

  buildInputs =
    [
      openimageio
      imath
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXt
      libGL
    ];

  cmakeFlags = [
    (lib.cmakeBool "MATERIALX_BUILD_OIIO" true)
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
    changelog = "https://github.com/AcademySoftwareFoundation/MaterialX/blob/${src.tag}/CHANGELOG.md";
    description = "Open standard for representing rich material and look-development content in computer graphics";
    homepage = "https://materialx.org";
    maintainers = [ lib.maintainers.gador ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
  };
}
