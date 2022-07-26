{ lib, buildPerlPackage, fetchFromGitHub, makeWrapper, openssh, GitRepository, URI, XMLMini }:

buildPerlPackage {
  pname = "ham-unstable";
  version = "2020-09-09";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "ae2a326f2efcdae0fa7c5bf0ba205b580fc91ecc";
    sha256 = "0m65pav2830y0ivwsy60dc4w457qlc0nqg43lji1kj2g96hmy2bw";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ openssh GitRepository URI XMLMini ];

  preConfigure = ''
    patchShebangs .
    touch Makefile.PL
    rm -f Makefile
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp -r . $out/lib/ham

    makeWrapper $out/lib/ham/ham $out/bin/ham --argv0 ham \
      --prefix PATH : ${openssh}/bin
  '';

  doCheck = false;

  meta = {
    description = "A tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = "https://github.com/kernkonzept/ham";
    license = "unknown"; # should be gpl2, but not quite sure
    maintainers = with lib.maintainers; [ aw ];
    mainProgram = "ham";
    platforms = lib.platforms.unix;
  };
}
