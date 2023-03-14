{ lib, stdenv, fetchFromGitLab, icmake
, libmilter, libX11, openssl, readline
, util-linux, yodl }:

stdenv.mkDerivation rec {
  pname = "bobcat";
  version = "5.10.01";

  src = fetchFromGitLab {
    sha256 = "sha256-QhjUIaPSDAvOt0ZCzQWASpG+GJaTviosGDrzrckhuhs=";
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

  # have to link to static gcc lib on aarch64-linux explicitly
  # https://github.com/NixOS/nixpkgs/issues/201254
  NIX_LDFLAGS = lib.optionalString (with stdenv.targetPlatform; isAarch64 && isLinux) "-lgcc";

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
