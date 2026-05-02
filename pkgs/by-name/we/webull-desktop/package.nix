{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  curl,
  curlWithGnuTls,
  dpkg,
  makeBinaryWrapper,
  alsa-lib,
  e2fsprogs,
  fontconfig,
  fribidi,
  gmp,
  gnutls,
  harfbuzz,
  libdrm,
  libGL,
  libgpg-error,
  libpq,
  libthai,
  libxrandr,
  nss,
  p11-kit,
  unixodbc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webull-desktop";
  version = "9.3.0";

  src = fetchurl {
    url = "https://u1sweb.webullfintech.com/us/Webull%20Desktop_9.3.0_9100000072_global_x64signed.deb";
    hash = "sha256-7xP4Q8eDMj2Pj/Zksr2gROJR1fPd4lz2zPpcAcu2o80=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    curl # libsentry.so requires SONAME libcurl.so.4 with the "CURL_OPENSSL_4" symbol

    # ... but libwbhttpsclient.so requires SONAME libcurl-gnutls.so.4 with the "CURL_GNUTLS_3" symbol
    (curlWithGnuTls.overrideAttrs (previousAttrs: rec {
      # Version 8.10.0 is the latest that can be easily patched to include the "CURL_GNUTLS_3" symbol
      version = "8.10.0";
      src = fetchurl {
        urls = [
          "https://curl.haxx.se/download/curl-${version}.tar.xz"
          "https://github.com/curl/curl/releases/download/curl-${
            builtins.replaceStrings [ "." ] [ "_" ] version
          }/curl-${version}.tar.xz"
        ];
        hash = "sha256-5rFC8OhelUdZ034mo2J+IngTdZW+gOOoYMQ1PkM15aA=";
      };

      # Keep the "CURL_GNUTLS_3" symbol which is sought by libwbhttpsclient.so
      patches = (previousAttrs.patches or [ ]) ++ [
        (builtins.toFile "curl-gnutls-keep-symbols-compatible.patch" ''
          --- a/lib/libcurl.vers.in
          +++ b/lib/libcurl.vers.in
          @@ -6,7 +6,7 @@ HIDDEN
               _save*;
           };

          -CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@4
          +CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@3
           {
             global: curl_*;
             local: *;
        '')
      ];

      # This prevents libsentry.so trying to load the 'wrong' libcurl.so
      #   (let libsentry.so load the stock NixOS libcurl.so that has the "CURL_OPENSSL_4" symbol)
      postFixup = (previousAttrs.postFixup or "") + ''
        patchelf --set-soname libcurl-gnutls.so.4 $out/lib/libcurl.so.4.8.0
      '';
    }))
    e2fsprogs
    fontconfig
    fribidi
    gmp
    gnutls
    harfbuzz
    libdrm
    libGL
    libgpg-error
    libthai
    libpq
    libxrandr
    nss
    p11-kit
    unixodbc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    mkdir $out/bin
    ln -s $out/usr/local/WebullDesktop/WebullDesktop $out/bin/webull-desktop
    substituteInPlace $out/usr/share/applications/WebullDesktop.desktop \
      --replace-fail "Exec=/usr/local/WebullDesktop/WebullDesktop" "Exec=webull-desktop" \
      --replace-fail "Icon=WebullDesktop.png" "Icon=WebullDesktop" \

    # Remove problematic bundled libraries for which we have installed local versions
    rm -f $out/usr/local/WebullDesktop/libgnutls.so*
    rm -f $out/usr/local/WebullDesktop/libnghttp2.so*

    # Make sure that WebullDesktop.desktop is found by launchers
    ln -s $out/usr/share $out/share

    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/platforms
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/bearer
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/iconengines
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/imageformats
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforminputcontexts
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforms
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/position
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/printsupport
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/sqldrivers
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/xcbglintegrations

    wrapProgram $out/usr/local/WebullDesktop/WebullDesktop --prefix LD_LIBRARY_PATH : $out:$out/usr/local/WebullDesktop/platforms:$out/usr/local/WebullDesktop/platformsbearer:$out/usr/local/WebullDesktop/platformsiconengines:$out/usr/local/WebullDesktop/platformsimageformats:$out/usr/local/WebullDesktop/platformsplatforminputcontexts:$out/usr/local/WebullDesktop/platformsplatforms:$out/usr/local/WebullDesktop/platformsposition:$out/usr/local/WebullDesktop/platformsprintsupport:$out/usr/local/WebullDesktop/platformssqldrivers:$out/usr/local/WebullDesktop/platformsxcbglintegrations:${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Webull desktop trading application";
    homepage = "https://www.webull.com/trading-platforms/desktop-app";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ fauxmight ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "webull-desktop";
  };
})
