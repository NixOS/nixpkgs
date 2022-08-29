{ lib
, stdenv
, fetchFromGitHub
, nix-update-script

# for passthru.tests
, bazel
, chromium
, grpc
, haskellPackages
, mercurial
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "re2";
  version = "2022-06-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
    sha256 = "sha256-UontAjOXpnPcOgoFHjf+1WSbCR7h58/U7nn4meT200Y=";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    # we're using gnu sed, even on darwin
    substituteInPlace Makefile  --replace "SED_INPLACE=sed -i '''" "SED_INPLACE=sed -i"
  '';

  buildFlags = lib.optionals stdenv.hostPlatform.isStatic [ "static" ];

  enableParallelBuilding = true;

  preCheck = "patchShebangs runtests";
  doCheck = true;
  checkTarget = if stdenv.hostPlatform.isStatic then "static-test" else "test";

  installTargets = lib.optionals stdenv.hostPlatform.isStatic [ "static-install" ];

  doInstallCheck = true;
  installCheckTarget = if stdenv.hostPlatform.isStatic then "static-testinstall" else "testinstall";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
    tests = {
      inherit
        chromium
        grpc
        mercurial;
      inherit (python3.pkgs)
        fb-re2
        google-re2;
      haskellPackages-re2 = haskellPackages.re2;
    };
  };

  meta = {
    homepage = "https://github.com/google/re2";
    description = "An efficient, principled regular expression library";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; all;
  };
}
