{ stdenv, fetchurl, fetchpatch, python, pkgconfig, cairo, x11, isPyPy }:

stdenv.mkDerivation rec {
  version = "1.10.0";
  name = "pycairo-${version}";
  src = if python.is_py3k or false
    then fetchurl {
      url = "http://cairographics.org/releases/pycairo-${version}.tar.bz2";
      sha256 = "1gjkf8x6hyx1skq3hhwcbvwifxvrf9qxis5vx8x5igmmgs70g94s";
    }
    else fetchurl {
      url = "http://cairographics.org/releases/py2cairo-${version}.tar.bz2";
      sha256 = "0cblk919wh6w0pgb45zf48xwxykfif16qk264yga7h9fdkq3j16k";
    };

  patches = [(fetchpatch {
    url = http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_unpack-1.patch;
    sha256 = "1bmrhq2nmhx4l5glvyi59r0hc7w5m56kz41frx7v3dcp8f91p7xd";
  })];

  patch_waf = fetchpatch {
    url = http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_python_3_4-1.patch;
    sha256 = "0xfl1i9dips2nykyg91f5h5r3xpk2hp1js1gq5z0hwjr0in55id4";
  };

  buildInputs = [ python pkgconfig cairo x11 ];

  configurePhase = ''
    (
      cd $(${python.executable} waf unpack)
      pwd
      patch -p1 < ${patch_waf}
    )

    ${python.executable} waf configure --prefix=$out
  '';
  buildPhase = "${python.executable} waf";
  installPhase = "${python.executable} waf install";

  meta.broken = isPyPy;
}
