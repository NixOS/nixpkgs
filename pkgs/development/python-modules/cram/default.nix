{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  bash,
  which,
}:

buildPythonPackage rec {
  version = "0.7";
  format = "setuptools";
  pname = "cram";

  nativeCheckInputs = [ which ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fadEWvLOFbkKrV7EeS+FfO9XhtcfFDd+nrmU2Lgzfy8=";
  };

  postPatch = ''
    patchShebangs scripts/cram
    substituteInPlace tests/test.t \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  checkPhase = ''
    scripts/cram tests
  '';

  meta = {
    description = "Simple testing framework for command line applications";
    mainProgram = "cram";
    homepage = "https://bitheap.org/cram/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jluttine ];
    # Tests fail on i686: https://hydra.nixos.org/build/52896671/nixlog/4
    broken = stdenv.isi686;
  };
}
