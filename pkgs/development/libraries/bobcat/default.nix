{ stdenv, fetchFromGitHub, icmake
, libmilter, libX11, openssl, readline
, utillinux, yodl }:

stdenv.mkDerivation rec {
  pname = "bobcat";
  version = "4.08.03";

  src = fetchFromGitHub {
    sha256 = "163mdl8hxids7123bjxmqhcaqyc1dv7hv8k33s713ac6lzawarq2";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  setSourceRoot = ''
    sourceRoot=$(echo */bobcat)
  '';

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with stdenv.lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = "https://fbb-git.github.io/bobcat/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
