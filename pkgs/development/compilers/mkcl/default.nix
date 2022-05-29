{ lib, stdenv, fetchFromGitHub, fetchpatch, makeWrapper, gmp, gcc }:

stdenv.mkDerivation rec {
  pname = "mkcl";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "jcbeaudoin";
    repo = "mkcl";
    rev = "v${version}";
    sha256 = "0i2bfkda20lfypis6i4m7srfz6miyf66d8knp693d6sms73m2l26";
  };

  patches = [
    # "Array sys_siglist[] never was part of the public interface. Replace it with calls to psiginfo()."
    (fetchpatch {
      name = "sys_siglist.patch";
      url = "https://github.com/jcbeaudoin/MKCL/commit/0777dd08254c88676f4f101117b10786b22111d6.patch";
      sha256 = "1dnr1jzha77nrxs22mclrcqyqvxxn6q1sfn35qjs77fi3jcinjsc";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ gmp ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "GMP_CFLAGS=-I${lib.getDev gmp}/include"
    "GMP_LDFLAGS=-L${gmp.out}/lib"
  ];

  # tinycc configure flags copied from the tinycc derivation.
  postConfigure = ''(
    cd contrib/tinycc
    ./configure --cc=cc \
      --elfinterp=$(< $NIX_CC/nix-support/dynamic-linker) \
      --crtprefix=${lib.getLib stdenv.cc.libc}/lib \
      --sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include \
      --libpaths=${lib.getLib stdenv.cc.libc}/lib
  )'';

  postInstall = ''
    wrapProgram $out/bin/mkcl --prefix PATH : "${gcc}/bin"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "ANSI Common Lisp Implementation";
    homepage = "https://common-lisp.net/project/mkcl/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tohl ];
  };
}
