{
  lib,
  stdenv,
  fetchurl,
  cmake,
  coreutils,
  python,
  root,
}:

let
  pythonVersion = with lib.versions; "${major python.version}${minor python.version}";
  withPython = python != null;
  # ensure that root is built with the same python interpreter, as it links against numpy
  root_py = if withPython then root.override { python3 = python; } else root;
in

stdenv.mkDerivation rec {
  pname = "hepmc3";
  version = "3.3.0";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-${version}.tar.gz";
    sha256 = "sha256-b4dgke3PfubQwNsE4IAFbonvwaYavmI1XZfOjnNXadY=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optional withPython python.pkgs.pythonImportsCheckHook;

  buildInputs = [
    root_py
  ] ++ lib.optional withPython python;

  # error: invalid version number in 'MACOSX_DEPLOYMENT_TARGET=11.0'
  preConfigure =
    lib.optionalString
      (stdenv.hostPlatform.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11")
      ''
        MACOSX_DEPLOYMENT_TARGET=10.16
      '';

  cmakeFlags =
    [
      "-DHEPMC3_CXX_STANDARD=17"
      "-DHEPMC3_ENABLE_PYTHON=${if withPython then "ON" else "OFF"}"
    ]
    ++ lib.optionals withPython [
      "-DHEPMC3_PYTHON_VERSIONS=${if python.isPy3k then "3.X" else "2.X"}"
      "-DHEPMC3_Python_SITEARCH${pythonVersion}=${placeholder "out"}/${python.sitePackages}"
    ];

  postInstall = ''
    substituteInPlace "$out"/bin/HepMC3-config \
      --replace-fail '$(greadlink' '$(${coreutils}/bin/readlink' \
      --replace-fail '$(readlink' '$(${coreutils}/bin/readlink'
  '';

  pythonImportsCheck = [ "pyHepMC3" ];

  meta = with lib; {
    description = "HepMC package is an object oriented, C++ event record for High Energy Physics Monte Carlo generators and simulation";
    mainProgram = "HepMC3-config";
    license = licenses.gpl3;
    homepage = "http://hepmc.web.cern.ch/hepmc/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
