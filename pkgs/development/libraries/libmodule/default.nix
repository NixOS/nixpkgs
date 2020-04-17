{ stdenv, fetchFromGitHub
, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libmodule";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "libmodule";
    rev = version;
    sha256 = "1cf81sl33xmfn5g150iqcdrjn0lpjlgp53mganwi6x7jda2qk7r6";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "C simple and elegant implementation of an actor library";
    homepage = "https://github.com/FedeDP/libmodule";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
