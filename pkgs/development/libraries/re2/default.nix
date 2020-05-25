{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "re2";
  version = "20190401";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "2019-04-01";
    sha256 = "018b8z3fgcr02rmhxdz80r363k40938cbgmk1c9b46k6xkc4q0hd";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    # we're using gnu sed, even on darwin
    substituteInPlace Makefile  --replace "SED_INPLACE=sed -i '''" "SED_INPLACE=sed -i"
  '';

  preCheck = "patchShebangs runtests";
  doCheck = true;
  checkTarget = "test";

  doInstallCheck = true;
  installCheckTarget = "testinstall";

  meta = {
    homepage = "https://github.com/google/re2";
    description = "An efficient, principled regular expression library";
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
  };
}
