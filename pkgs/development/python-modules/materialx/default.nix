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
  darwinMinVersionHook,
  apple-sdk_14,
}:

buildPythonPackage rec {
  pname = "materialx";
  version = "1.38.10";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    rev = "v${version}";
    hash = "sha256-/kMHmW2dptZNtjuhE5s+jvPRIdtY+FRiVtMU+tiBgQo=";
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
      (darwinMinVersionHook "10.15")
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
    changelog = "https://github.com/AcademySoftwareFoundation/MaterialX/blob/${src.rev}/CHANGELOG.md";
    description = "Open standard for representing rich material and look-development content in computer graphics";
    homepage = "https://materialx.org";
    maintainers = [ lib.maintainers.gador ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
  };
}
