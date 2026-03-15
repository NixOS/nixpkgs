{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  gfortran,
  lapack,
  blas,
  autoreconfHook,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "control";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "pkg-control";
    tag = "${pname}-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-NOZi003brDQ5nVyP7w5n7hxhafbiBwMPErhhTQhn2bw=";
  };

  # Running autoreconfHook inside the src directory fixes a compile issue about
  # the config.h header for control missing.
  # This is supposed to be handled by control's top-level Makefile, but does not
  # appear to be working. This manually forces it instead.
  preAutoreconf = ''
    pushd src
  '';

  postAutoreconf = ''
    popd
  '';

  nativeBuildInputs = [
    gfortran
    autoreconfHook
  ];

  buildInputs = [
    lapack
    blas
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "control-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/control/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Computer-Aided Control System Design (CACSD) Tools for GNU Octave, based on the proven SLICOT Library";
  };
}
