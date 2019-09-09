{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec{
  pname = "rapidcheck";
  version = "unstable-2018-09-27";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = "rapidcheck";
    rev   = "de54478fa35c0d9cea14ec0c5c9dfae906da524c";
    sha256 = "0n8l0mlq9xqmpkgcj5xicicd1my2cfwxg25zdy8347dqkl1ppgbs";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    cp ../extras/boost_test/include/rapidcheck/boost_test.h $out/include/rapidcheck
  '';

  meta = with stdenv.lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
