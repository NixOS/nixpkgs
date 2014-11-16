{ stdenv, fetchurl, writeScript, patchelf, glib, opensc, openssl, openct
, libtool, pcsclite, zlib
}:

stdenv.mkDerivation rec {
  name = "libopensc-dnie-1.4.6-2";

  src = if stdenv.system == "i686-linux" then (fetchurl {
      url = http://www.dnielectronico.es/descargas/PKCS11_para_Sistemas_Unix/1.4.6.Ubuntu_Jaunty_32/Ubuntu_Jaunty_opensc-dnie_1.4.6-2_i386.deb.tar;
      sha256 = "1i6r9ahjr0rkcxjfzkg2rrib1rjsjd5raxswvvfiya98q8rlv39i";
    })
    else if stdenv.system == "x86_64-linux" then (fetchurl { url = http://www.dnielectronico.es/descargas/PKCS11_para_Sistemas_Unix/1.4.6.Ubuntu_Jaunty_64/Ubuntu_Jaunty_opensc-dnie_1.4.6-2_amd64.deb.tar;
      sha256 = "1py2bxavdcj0crhk1lwqzjgya5lvyhdfdbr4g04iysj56amxb7f9";
    })
    else throw "Architecture not supported";

  buildInputs = [ patchelf glib ];

  builder = writeScript (name + "-builder.sh") ''
    source $stdenv/setup
    tar xf $src
    ar x opensc-dnie*
    tar xf data.tar.gz

    RPATH=${glib}/lib:${opensc}/lib:${openssl}/lib:${openct}/lib:${libtool}/lib:${pcsclite}/lib:${stdenv.gcc.libc}/lib:${zlib}/lib

    for a in "usr/lib/"*.so*; do
        if ! test -L $a; then
            patchelf --set-rpath $RPATH $a
        fi
    done

    sed -i s,/usr,$out, "usr/lib/pkgconfig/"*

    mkdir -p $out
    cp -R usr/lib $out
    cp -R usr/share $out
  '';

  passthru = {
    # This will help keeping the proper opensc version when using this libopensc-dnie library
    inherit opensc;
  };

  meta = {
    homepage = http://www.dnielectronico.es/descargas/;
    description = "Opensc plugin to access the Spanish national ID smartcard";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
