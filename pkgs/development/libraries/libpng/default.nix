{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  version = "1.6.19";
  sha256 = "1s1mmkl79ghiczi2x2rbnp6y70v4c5pr8g3icxn9h5imymbmc71i";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0bgqkac16yhl0zwjzq2zwkixg2l2x3a6blbk3k0wqz0lza2a6jrh";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    inherit sha256;
  };
  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  outputs = [ "dev" "out" "man" ];

  propagatedBuildInputs = [ zlib ];

  preConfigure = "export bin=$dev";

  doCheck = true;

  postInstall = ''mv "$out/bin" "$dev/bin"'';

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
