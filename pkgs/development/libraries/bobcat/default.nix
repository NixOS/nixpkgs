{ lib, stdenv, fetchFromGitLab, icmake
, libmilter, libX11, openssl, readline
, util-linux, yodl }:

stdenv.mkDerivation rec {
  pname = "bobcat";
  version = "5.11.01";

  src = fetchFromGitLab {
    sha256 = "sha256-JLJKaJmztputIon9JkKzpm3Ch60iwm4Imh9p42crYzA=";
    domain = "gitlab.com";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline util-linux ];
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

  meta = with lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = "https://fbb-git.gitlab.io/bobcat/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
