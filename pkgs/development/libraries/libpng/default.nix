{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  version = "1.6.20";
  sha256 = "12wis4rlisfnw79pj2778m42m94xpi9nq8m385hxk11lkyg9biam";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "11xgal9qk6fmqdgcb37xg55f2y58wizszw54p1pyq855d2xpwfz6";
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
