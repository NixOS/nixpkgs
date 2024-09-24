{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  darwin,
  libX11,
  libXt,
  libGL,
  openimageio,
  imath,
  python,
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        OpenGL
        Cocoa
      ]
    )
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXt
      libGL
    ];

  cmakeFlags = [
    (lib.cmakeBool "MATERIALX_BUILD_OIIO" true)
    (lib.cmakeBool "MATERIALX_BUILD_PYTHON" true)
    # don't build MSL shader back-end on x86_x64-darwin, as it requires a newer SDK with metal support
    (lib.cmakeBool "MATERIALX_BUILD_GEN_MSL" (
      stdenv.hostPlatform.isLinux || (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin)
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
