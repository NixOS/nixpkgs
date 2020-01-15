{ stdenv, fetchFromGitHub
, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libmodule";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "libmodule";
    rev = version;
    sha256 = "1qn54pysdm0q7v1gnisd43i5i4ylf8s8an77jk6jd8qimysv08mx";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "C simple and elegant implementation of an actor library";
    homepage = https://github.com/FedeDP/libmodule;
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
