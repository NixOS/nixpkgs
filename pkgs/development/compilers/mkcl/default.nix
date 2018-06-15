{ stdenv, fetchFromGitHub, makeWrapper, gmp, gcc }:

with stdenv.lib; stdenv.mkDerivation rec {
  name = "mkcl-${version}";
  version = "1.1.10.2017-11-14";

  src = fetchFromGitHub {
    owner = "jcbeaudoin";
    repo = "mkcl";
    rev = "d3f5afe945907153db2be5a17a419966f83d7653";
    sha256 = "1jfmnh96b5dy1874a9y843vihd14ya4by46rb4h5izldp6x3j3kl";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ gmp ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "GMP_CFLAGS=-I${gmp.dev}/include"
    "GMP_LDFLAGS=-L${gmp.out}/lib"
  ];

  # tinycc configure flags copied from the tinycc derivation.
  postConfigure = ''(
    cd contrib/tinycc
    ./configure --cc=cc \
      --elfinterp=$(< $NIX_CC/nix-support/dynamic-linker) \
      --crtprefix=${getLib stdenv.cc.libc}/lib \
      --sysincludepaths=${getDev stdenv.cc.libc}/include:{B}/include \
      --libpaths=${getLib stdenv.cc.libc}/lib
  )'';

  postInstall = ''
    wrapProgram $out/bin/mkcl --prefix PATH : "${gcc}/bin"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = https://common-lisp.net/project/mkcl/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tohl ];
  };
}
