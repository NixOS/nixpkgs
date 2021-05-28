{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "re2";
  version = "20201001";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "2020-10-01";
    sha256 = "0a5f7av1pk6p3jxc2w6prl00lyrplap97m68hnhw7jllnwljk0bx";
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
