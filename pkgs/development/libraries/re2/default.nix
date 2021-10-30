{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "re2";
  version = "2021-09-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = version;
    sha256 = "1fyhypw345xz8zdh53gz6j1fwgrx0gszk1d349ja37dpxh4jp2jh";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    # we're using gnu sed, even on darwin
    substituteInPlace Makefile  --replace "SED_INPLACE=sed -i '''" "SED_INPLACE=sed -i"
  '';

  buildFlags = lib.optionals stdenv.hostPlatform.isStatic [ "static" ];

  preCheck = "patchShebangs runtests";
  doCheck = true;
  checkTarget = "test";

  installTargets = lib.optionals stdenv.hostPlatform.isStatic [ "static-install" ];

  doInstallCheck = true;
  installCheckTarget = "testinstall";

  meta = {
    homepage = "https://github.com/google/re2";
    description = "An efficient, principled regular expression library";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; all;
  };
}
