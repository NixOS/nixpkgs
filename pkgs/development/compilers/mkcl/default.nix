{ stdenv, fetchFromGitHub, makeWrapper, gmp, gcc }:

with stdenv.lib; stdenv.mkDerivation rec {
  pname = "mkcl";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "jcbeaudoin";
    repo = "mkcl";
    rev = "v${version}";
    sha256 = "0i2bfkda20lfypis6i4m7srfz6miyf66d8knp693d6sms73m2l26";
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
