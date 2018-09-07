{ stdenv
, fetchurl
, fetchpatch
, makeWrapper
}:

stdenv.mkDerivation rec {
  version = "1.018.1";
  name = "sympow-${version}";

  src = fetchurl {
    # Original website no longer reachable
    url = "mirror://sageupstream/sympow/sympow-${version}.tar.bz2";
    sha256 = "0hphs7ia1wr5mydf288zvwj4svrymfpadcg3pi6w80km2yg5bm3c";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  configurePhase = ''
    runHook preConfigure
    ./Configure # doesn't take any options
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    install -D datafiles/* --target-directory "$out/share/sympow/datafiles/"
    install *.gp "$out/share/sympow/"
    install -Dm755 sympow "$out/share/sympow/sympow"
    install -D new_data "$out/bin/new_data"

    makeWrapper "$out/share/sympow/sympow" "$out/bin/sympow" \
      --run 'export SYMPOW_LOCAL="$HOME/.local/share/sympow"' \
      --run 'if [ ! -d "$SYMPOW_LOCAL" ]; then
        mkdir -p "$SYMPOW_LOCAL" 
        cp -r ${placeholder "out"}/share/sympow/* "$SYMPOW_LOCAL"
        chmod -R +xw "$SYMPOW_LOCAL"
    fi' \
      --run 'cd "$SYMPOW_LOCAL"'
    runHook postInstall
  '';

  patches = [
    # don't hardcode paths
    (fetchpatch {
      name = "do_not_hardcode_paths.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympow/patches/Configure.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1611p8ra8zkxvmxn3gm2l64bd4ma4m6r4vd6vwswcic91k1fci04";
    })

    # bug on some platforms in combination with a newer gcc:
    # https://trac.sagemath.org/ticket/11920
    (fetchpatch {
      name = "fix_newer_gcc1.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympow/patches/fpu.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "14gfa56w3ddfmd4d5ir9a40y2zi43cj1i4d2l2ij9l0qlqdy9jyx";
    })
    (fetchpatch {
      name = "fix_newer_gcc2.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympow/patches/execlp.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "190gqhgz9wgw4lqwz0nwb1izc9zffx34bazsiw2a2sz94bmgb54v";
    })

    # fix pointer initialization bug (https://trac.sagemath.org/ticket/22862)
    (fetchpatch {
      name = "fix_pointer_initialization1.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympow/patches/initialize-tacks.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "02341vdbbidfs39s26vi4n5wigz619sw8fdbl0h9qsmwwhscgf85";
    })
    (fetchpatch {
      name = "fix_pointer_initialization2.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/sympow-datafiles.patch?h=packages/sympow";
      sha256 = "1m0vz048layb47r1jjf7fplw650ccc9x0w3l322iqmppzmv3022a";
    })
  ];

  meta = with stdenv.lib; {
    description = "A package to compute special values of symmetric power elliptic curve L-functions";
    license = {
      shortName = "sympow";
      fullName = "Custom, BSD-like. See COPYING file.";
      free = true;
    };
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.all;
  };
}
