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
    sha256 = "0bvz6fwdi55rkrz3f50zsy35gvvwhlppki2yml5bj5ffy9d499vx";
  };

  postPatch = ''
    patchShebangs scripts/cram
    substituteInPlace tests/test.t \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  checkPhase = ''
    scripts/cram tests
  '';

  meta = with lib; {
    description = "Simple testing framework for command line applications";
    mainProgram = "cram";
    homepage = "https://bitheap.org/cram/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jluttine ];
    # Tests fail on i686: https://hydra.nixos.org/build/52896671/nixlog/4
    broken = stdenv.hostPlatform.isi686;
  };
}
