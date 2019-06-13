{ stdenv
, fetchurl
, fetchpatch
, pari
}:

stdenv.mkDerivation rec {
  version = "1.23";
  pname = "lcalc";
  name = "${pname}-${version}";

  src = fetchurl {
    # original at http://oto.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/L-${version}.tar.gz, no longer available
    # "newer" version at google code https://code.google.com/archive/p/l-calc/source/default/source
    url = "mirror://sageupstream/lcalc/lcalc-${version}.tar.bz2";
    sha256 = "1c6dsdshgxhqppjxvxhp8yhpxaqvnz3d1mlh26r571gkq8z2bm43";
  };

  preConfigure = "cd src";

  buildInputs = [
    pari
  ];

  patches = [
    # Port to newer pari
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/pari-2.7.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1x3aslldm8njjm7p9g9s9w2c91kphnci2vpkxkrcxfihw3ayss6c";
    })

    # Uncomment the definition of lcalc_to_double(const long double& x).
    # (Necessary for GCC >= 4.6.0, cf. https://trac.sagemath.org/ticket/10892)
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/Lcommon.h.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0g4ybvsrcv48rmlh1xjnkms19jp25k58azv6ds1f2cm34hxs8fdx";
    })

    # Include also <time.h> in Lcommandline_numbertheory.h (at least required
    # on Cygwin, cf. https://trac.sagemath.org/ticket/9845)
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/time.h.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1brf04n11kkc43ylagf8dm32j5r2g9zv51dp5wag1mpm4p04l7cl";
    })

    # Fix for gcc >4.6
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/lcalc-1.23_default_parameters_1.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0i2yvxm5fx4z0v6m4srgh8rj98kijmlvyirlxf1ky0bp2si6bpka";
    })

    # gcc 5.1
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/lcalc-1.23_default_parameters_2.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0dqwmxpm9wb53qbypsyfkgsvk2f8nf67sydphd4dkc2vw4yz6vlh";
    })

    # based on gentoos makefile patch -- fix paths, adhere to flags
    ./makefile.patch

    # (fetchpatch {
    #   name = "default-double.patch";
    #   url = "https://github.com/dimpase/lcalc/pull/1/commits/0500c67b6aa1f492715591669f6647c8f7a3ea59.patch";
    #   sha256 = "0dqwmxpm9wb53qbypsyfkgsvk2f8nf67sydphd4dkc2vw4yz6vla";
    # })

    (fetchpatch {
      name = "c++11.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/lcalc-c++11.patch?h=packages/lcalc&id=3607b97df5a8c231191115b0cb5c62426b339e71";
      sha256 = "1ccrl61lv2vvx8ggldq54m5d0n1iy6mym7qz0i8nj6yj0dshnpk3";
    })
  ] ++ stdenv.lib.optional stdenv.isDarwin
  (fetchpatch {
    url = "https://git.sagemath.org/sage.git/plain/build/pkgs/lcalc/patches/clang.patch";
    sha256 = "0bb7656z6cp6i4p2qj745cmq0lhh52v2akl9whi760dynfdxbl18";
  });

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/Makefile --replace g++ c++
  '';

  installFlags = [
    "DESTDIR=$(out)"
  ];

  makeFlags = [
    "PARI_DEFINE=-DINCLUDE_PARI"
    "PARI_PREFIX=${pari}"
  ];

  meta = with stdenv.lib; {
    homepage = http://oto.math.uwaterloo.ca/~mrubinst/L_function_public/L.html;
    description = "A program for calculating with L-functions";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.all;
  };
}
