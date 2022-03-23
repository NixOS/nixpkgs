{ lib, stdenv, fetchFromGitHub, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "re2";
  version = "2022-02-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
    sha256 = "sha256-3RspCfJD2jV7GYuzeBUcxkZsdHyL14kaz8lSoIrH7b8=";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    # we're using gnu sed, even on darwin
    substituteInPlace Makefile  --replace "SED_INPLACE=sed -i '''" "SED_INPLACE=sed -i"
  '';

  buildFlags = lib.optionals stdenv.hostPlatform.isStatic [ "static" ];

  enableParallelBuilding = true;
  # Broken when shared/static are tested in parallel:
  #   cp: cannot create regular file 'obj/testinstall.cc': File exists
  #   make: *** [Makefile:334: static-testinstall] Error 1
  # Will be fixed by https://code-review.googlesource.com/c/re2/+/59830
  enableParallelChecking = false;

  preCheck = "patchShebangs runtests";
  doCheck = true;
  checkTarget = "test";

  installTargets = lib.optionals stdenv.hostPlatform.isStatic [ "static-install" ];

  doInstallCheck = true;
  installCheckTarget = "testinstall";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = {
    homepage = "https://github.com/google/re2";
    description = "An efficient, principled regular expression library";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; all;
  };
}
