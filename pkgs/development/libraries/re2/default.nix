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
  version = "2022-04-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
    sha256 = "sha256-ywmXIAyVWYMKBOsAndcq7dFYpn9ZgNz5YWTPjylXxsk=";
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
