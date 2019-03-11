{ stdenv
, buildPythonPackage
, fetchurl
, pkgs
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "pysvn";
  version = "1.8.0";
  disabled = isPy3k;
  format = "other";

  src = fetchurl {
    url = "http://pysvn.barrys-emacs.org/source_kits/${pname}-${version}.tar.gz";
    sha256 = "0srjr2qgxfs69p65d9vvdib2lc142x10w8afbbdrqs7dhi46yn9r";
  };

  buildInputs = [ pkgs.subversion pkgs.apr pkgs.aprutil pkgs.expat pkgs.neon pkgs.openssl ]
    ++ (if stdenv.isLinux then [pkgs.e2fsprogs] else []);

  # There seems to be no way to pass that path to configure.
  NIX_CFLAGS_COMPILE="-I${pkgs.aprutil.dev}/include/apr-1";

  preConfigure = ''
    cd Source
    ${python.interpreter} setup.py backport
    ${python.interpreter} setup.py configure \
      --apr-inc-dir=${pkgs.apr.dev}/include \
      --apu-inc-dir=${pkgs.aprutil.dev}/include \
      --apr-lib-dir=${pkgs.apr.out}/lib \
      --svn-lib-dir=${pkgs.subversion.out}/lib \
      --svn-bin-dir=${pkgs.subversion.out}/bin \
      --svn-root-dir=${pkgs.subversion.dev}
  '' + (if !stdenv.isDarwin then "" else ''
    sed -i -e 's|libpython2.7.dylib|lib/libpython2.7.dylib|' Makefile
  '');

  checkPhase = "make -C ../Tests";

  installPhase = ''
    dest=$(toPythonPath $out)/pysvn
    mkdir -p $dest
    cp pysvn/__init__.py $dest/
    cp pysvn/_pysvn*.so $dest/
    mkdir -p $out/share/doc
    mv -v ../Docs $out/share/doc/pysvn-1.7.2
    rm -v $out/share/doc/pysvn-1.7.2/generate_cpp_docs_from_html_docs.py
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for Subversion";
    homepage = http://pysvn.tigris.org/;
    license = licenses.asl20;
  };

}
