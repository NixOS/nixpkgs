args: with args;

stdenv.mkDerivation rec {
  name = "kdelibs-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0c4s1677fa3d1dknz0z0qacsx47sx0spnz0wdw1zycirwbcids7s";
  };

  propagatedBuildInputs = [
    inputproto kbproto scrnsaverproto xextproto xf86miscproto xf86vidmodeproto
    xineramaproto xproto libICE libX11 libXau libXcomposite libXcursor
    libXdamage libXdmcp libXext libXfixes libXft libXi libXpm libXrandr
    libXrender libXScrnSaver libXt libXtst libXv libXxf86misc libxkbfile zlib
    perl qt openssl pcre pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 shared_mime_info alsaLib libungif cups avahi
    gettext enchant openexr aspell stdenv.gcc.libc jasper kerberos fam
  ] ++ (with kde4.support; [soprano strigi]);
  buildInputs = [ cmake ];
  patchPhase = "cp ${findIlmBase} ../cmake/modules/FindIlmBase.cmake;
  cp $findOpenEXR ../cmake/modules/FindOpenEXR.cmake;
  sed -e 's@Soprano/DummyModel@Soprano/Util/DummyModel@' -i ../nepomuk/core/resourcemanager.cpp;";

  findIlmBase = ./FindIlmBase.cmake;
  findOpenEXR = ./FindOpenEXR.cmake;
  setupHook=./setup.sh;
}
/*
   propagated, but not referenced:
/nix/store/ww1bjw6fiabfsn56h2cx65v7rpkh3cmv-inputproto-1.4.2.1
/nix/store/nqxdqmbwclw6233lpjavahbnv84cfjr5-kbproto-1.0.3
/nix/store/6a3dxmym07f5may0z25qj1dgpj3l6qyn-scrnsaverproto-1.1.0
/nix/store/vjsc1ljsvc6rn7g6hfbaq1r0hw96yv3k-xextproto-7.0.2
/nix/store/dm9hi43nh91ndfa8sgpl24jqr77v92w1-xf86miscproto-0.9.2
/nix/store/j4xl965n8r5cd72bmawc0k1vsayf93ws-xf86vidmodeproto-2.2.2
/nix/store/wc94gcwc3r218vjn1sx809pv8kck22ba-xineramaproto-1.1.2
/nix/store/n2dhcd6c9mszzyv0ndra2cjpi2lgx3b2-xproto-7.0.10
/nix/store/ms4pk7h5xba8q29is2q9c04s8q8zq49n-libXcomposite-0.4.0
/nix/store/cdnnv706cq8iwjn7qgasyn84j2n6hv13-libXdamage-1.0.4
/nix/store/4cxf36jhfvgr3n6bhs4hyhps2jhr5jv6-libXi-1.1.3
/nix/store/sz14chn1d6w1f9ij0b1v58q9ynkg3ngb-libXrandr-1.2.2
/nix/store/4yfl5kw66c6dwny9asppj9hayp9mcfkv-libXScrnSaver-1.1.2
/nix/store/jxj0gw060xpi9hdkwimnm8lmwhmgkfl5-libXt-1.0.4
/nix/store/czqsrjh3qmi1vh95ln89hd0xizfkqr2p-libXv-1.0.3
/nix/store/r7cc3mdwpr6v98am12j01ni2apjvnb4d-libXxf86misc-1.0.1
/nix/store/vchnj0hkvwndnmz8qm19sx851q55jqca-libxkbfile-1.0.4
/nix/store/fcwjqhwq2hzl813n1yhbg3c16877192p-perl-5.8.8
/nix/store/vn0h5gxpqba7a5wygx2i4y6kph28nyqx-pkgconfig-0.22
/nix/store/wq5jzrwixqgwwbay3g6wyml899xq0sjl-libtiff-3.8.2
/nix/store/33p2bjmvvlidiqm9f7kj5fi9l9njfyvy-expat-2.0.1
/nix/store/b0p33yl24m9b8l0pdbn2ws7x8kqqvr12-libtool-1.5.22
/nix/store/p3kbqjdij0faffsxzlsa0r6cx0244ckz-freetype-2.3.1
/nix/store/i2wz2sh2svlbf105sn0513hgxc3fd2hm-shared-mime-info-0.23
/nix/store/c0jbrrw31az5vqc8rawyl6cx3mbb4m2i-cups-1.2.10
/nix/store/mw7ycjzji2zkmv82ig9lyxsk4zxab488-avahi-0.6.22
/nix/store/wm4xdf13rpikl0vs03bfrq6cgjc2caf9-gettext-0.17
/nix/store/jbyj4fyfpqsl8v04v98md64cpv4gr0l5-qca-2.0.0dev
/nix/store/qylkj2031zhki3sxg59h07d0bpisfl7v-gmm-svn
/nix/store/b743sdkbwfq1imfid54vwhv41m6qh6sr-eigen-1.0.5
/nix/store/pzjba22xmrbh2cdsaybdr2rg5srqknrz-taglib-1.4svn
/nix/store/asb1vki40g0wppbazagpbvr51g8lf7gg-qimageblitz-4.0.0svn
*/
