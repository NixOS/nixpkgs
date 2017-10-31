{ lib, fetchurl, fetchpatch, python, buildPythonPackage, pkgconfig, cairo, xlibsWrapper, isPyPy, isPy35, isPy36, isPy3k }:

if (isPyPy) then throw "pycairo not supported for interpreter ${python.executable}" else let

  patch_waf = fetchpatch {
    url = http://www.linuxfromscratch.org/patches/blfs/8.0/pycairo-1.10.0-waf_python_3_4-1.patch;
    sha256 = "0xfl1i9dips2nykyg91f5h5r3xpk2hp1js1gq5z0hwjr0in55id4";
  };
  patch_waf-py3_5 = ./waf-py3_5.patch;

in buildPythonPackage rec {
  pname = "pycairo";
  version = "1.10.0";
  name = "${pname}-${version}";
  format = "other";

  src = if isPy3k
    then fetchurl {
      url = "http://cairographics.org/releases/pycairo-${version}.tar.bz2";
      sha256 = "1gjkf8x6hyx1skq3hhwcbvwifxvrf9qxis5vx8x5igmmgs70g94s";
    }
    else fetchurl {
      url = "http://cairographics.org/releases/py2cairo-${version}.tar.bz2";
      sha256 = "0cblk919wh6w0pgb45zf48xwxykfif16qk264yga7h9fdkq3j16k";
    };

  patches = [
    (fetchpatch {
      url = http://www.linuxfromscratch.org/patches/blfs/8.0/pycairo-1.10.0-waf_unpack-1.patch;
      sha256 = "1bmrhq2nmhx4l5glvyi59r0hc7w5m56kz41frx7v3dcp8f91p7xd";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python cairo xlibsWrapper ];

  configurePhase = ''
    (
      cd $(${python.executable} waf unpack)
      patch -p1 < ${patch_waf}
      ${lib.optionalString (isPy35 || isPy36) "patch -p1 < ${patch_waf-py3_5}"}
    )

    ${python.executable} waf configure --prefix=$out
  '';
  buildPhase = "${python.executable} waf";
  installPhase = "${python.executable} waf install";

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
}
