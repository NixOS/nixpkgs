{ stdenv, callPackage, fetchFromGitHub, enableStatic ? false, enableShared ? true }:
let
  yesno = b: if b then "yes" else "no";
in stdenv.mkDerivation rec {
  pname = "libbacktrace";
  version = "2018-06-05";
  src = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = pname;
    rev = "5a99ff7fed66b8ea8f09c9805c138524a7035ece";
    sha256 = "0mb81x76k335iz3h5nqxsj4z3cz2a13i33bkhpk6iffrjz9i4dhz";
  };
  configureFlags = [
    "--enable-static=${yesno enableStatic}"
    "--enable-shared=${yesno enableShared}"
  ];
  meta = with stdenv.lib; {
    description = "A C library that may be linked into a C/C++ program to produce symbolic backtraces";
    homepage = https://github.com/ianlancetaylor/libbacktrace;
    maintainers = with maintainers; [ twey ];
    license = with licenses; [ bsd3 ];
  };
}
