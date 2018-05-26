{stdenv, fetchurl, writeText, zlib, gperf}:

stdenv.mkDerivation rec {
  name = "libid3tag-${version}";
  version = "0.15.1b";

  src = fetchurl {
    url = mirror://sourceforge/mad/libid3tag-0.15.1b.tar.gz;
    sha256 = "63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false;

  propagatedBuildInputs = [ zlib gperf ];

  patches = [ ./debian-patches.patch ];

  preConfigure = ''
    configureFlagsArray+=(
      --includedir=$dev/include
    )
  '';

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    cp ${./id3tag.pc} $dev/lib/pkgconfig/id3tag.pc
    substituteInPlace $dev/lib/pkgconfig/id3tag.pc \
      --subst-var-by out $out \
      --subst-var-by dev $dev \
      --subst-var-by version "${version}"
  '';

  meta = with stdenv.lib; {
    description = "ID3 tag manipulation library";
    homepage = http://mad.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.fuuzetsu ];
    platforms = platforms.unix;
  };
}
