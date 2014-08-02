{stdenv, fetchurl, writeText, zlib, gperf}:

stdenv.mkDerivation rec {
  version = "0.15.1b";

  name = "libid3tag-${version}";

  src = fetchurl {
    url = mirror://sourceforge/mad/libid3tag-0.15.1b.tar.gz;
    sha256 = "63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151";
  };

  propagatedBuildInputs = [ zlib gperf ];

  patches = [ ./debian-patches.patch ];

  postInstall = let pkgconfigFile = writeText "id3tag.pc" ''
    prefix=@out@
    exec_prefix=''${prefix}
    libdir=''${exec_prefix}/lib
    includedir=''${exec_prefix}/include

    Name: libid3tag
    Description: ID3 tag manipulation library
    Version: ${version}

    Libs: -L''${libdir} -lid3tag
    Cflags: -I''${includedir}
    '';
  in ''
      ensureDir $out/share/pkgconfig
      cp ${pkgconfigFile} $out/share/pkgconfig/id3tag.pc
      substituteInPlace $out/share/pkgconfig/id3tag.pc \
        --subst-var-by out $out
  '';

  meta = with stdenv.lib; {
    description = "ID3 tag manipulation library";
    homepage = http://mad.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
