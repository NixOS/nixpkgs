{ lib, stdenv, callPackage, fetchFromGitHub
, enableStatic ? stdenv.hostPlatform.isStatic
, enableShared ? !stdenv.hostPlatform.isStatic
}:
let
  yesno = b: if b then "yes" else "no";
in stdenv.mkDerivation rec {
  pname = "libbacktrace";
  version = "2020-05-13";
  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = pname;
    rev = "9b7f216e867916594d81e8b6118f092ac3fcf704";
    sha256 = "0qr624v954gnfkmpdlfk66sxz3acyfmv805rybsaggw5gz5sd1nh";
  };
  configureFlags = [
    "--enable-static=${yesno enableStatic}"
    "--enable-shared=${yesno enableShared}"
  ];
  meta = with lib; {
    description = "A C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = "https://github.com/ianlancetaylor/libbacktrace";
    maintainers = with maintainers; [ twey ];
    license = with licenses; [ bsd3 ];
  };
}
