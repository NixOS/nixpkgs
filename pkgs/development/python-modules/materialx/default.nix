{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  libx11,
  libxt,
  libGL,
  openimageio,
  imath,
  python,
}:

buildPythonPackage rec {
  pname = "materialx";
  version = "1.39.5";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "MaterialX";
    rev = "v${version}";
    hash = "sha256-7aY1SI5b5hVjvTtucQh6XpkwkhPZWDhsTVYLKM667/k=";
  };

  pyproject = false;

  nativeBuildInputs = [
    cmake
    setuptools
  ];

  buildInputs = [
    openimageio
    imath
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libx11
    libxt
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
