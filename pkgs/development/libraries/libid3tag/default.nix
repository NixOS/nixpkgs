{ lib, stdenv, fetchurl, zlib, gperf_3_0 }:

stdenv.mkDerivation rec {
  pname = "libid3tag";
  version = "0.15.1b";

  src = fetchurl {
    url = "mirror://sourceforge/mad/libid3tag-${version}.tar.gz";
    sha256 = "63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false;

  strictDeps = true;

  nativeBuildInputs = [ gperf_3_0 ];

  buildInputs = [ zlib ];

  patches = [
    ./debian-patches.patch
    ./CVE-2017-11550-and-CVE-2017-11551.patch
  ];

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

  meta = with lib; {
    description = "ID3 tag manipulation library";
    homepage = "https://mad.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
