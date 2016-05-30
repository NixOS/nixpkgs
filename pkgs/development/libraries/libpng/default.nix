{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  version = "1.6.21";
  sha256 = "10r0xqasm8fi0dx95bpca63ab4myb8g600ypyndj2r4jxd4ii3vc";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0wwcc52yzjaxvpfkicz20j7yzpy02hpnsm4jjlvw74gy4qjhx9vd";
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

  # it's hard to cross-run tests and some check programs didn't compile anyway
  makeFlags = stdenv.lib.optional (!doCheck) "check_PROGRAMS=";
  doCheck = ! stdenv ? cross;

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
