{
  boost,
  cmake,
  fetchFromGitHub,
  gmp,
  gnuradio,
  lib,
  mkDerivation,
  pkg-config,
  python,
  spdlog,
  unstableGitUpdater,
}:

mkDerivation {
  pname = "gr-difi";
  version = "0-unstable-2025-08-16";

  src = fetchFromGitHub {
    owner = "DIFI-Consortium";
    repo = "gr-difi";
    rev = "330dd7f245f840903d034603850222a08c5a7c66";
    hash = "sha256-zztnTaeYEWw9OAvgvy99aoj5UiJ/dOKQQWF+7Lfp59A=";
  };

  buildInputs = [
    boost
    gmp
    gnuradio
    spdlog
  ]
  ++ lib.optionals (gnuradio.hasFeature "python-support") [
    python.pkgs.pybind11
    python.pkgs.numpy
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "GNU Radio Digital Intermediate Frequency Interoperability (DIFI) Out of Tree Module";
    homepage = "https://github.com/DIFI-Consortium/gr-difi";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jmbaur ];
    platforms = lib.platforms.linux;
  };
}
