{ lib, stdenv, fetchFromGitHub, fetchpatch, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "re2";
  version = "2021-11-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
    sha256 = "sha256-q8u7xNp6n17F6twPoVkix8iCKPWUN+qg6rhSR4Dv+bI=";
  };

  patches = [
    # Pull upstreal fix for parallel testing.
    (fetchpatch {
      name = "parallel-tests.patch";
      url = "https://github.com/google/re2/commit/9262284a7edc1b83e7172f4ec2d7967d695e7420.patch";
      sha256 = "1knhfx9cs4841r09jw4ha6mdx9qwpvlcxvd04i8vr84kd0lilqms";
    })
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    # we're using gnu sed, even on darwin
    substituteInPlace Makefile  --replace "SED_INPLACE=sed -i '''" "SED_INPLACE=sed -i"
  '';

  buildFlags = lib.optionals stdenv.hostPlatform.isStatic [ "static" ];

  enableParallelBuilding = true;

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
