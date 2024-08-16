{ lib
, stdenv
, fetchurl
, fetchpatch
, ncurses
, alsa-lib
, CoreServices
, AudioUnit
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "speech_tools";
  version = "2.5.0";

  src = fetchurl {
    url = "http://www.festvox.org/packed/festival/${lib.versions.majorMinor version}/speech_tools-${version}-release.tar.gz";
    sha256 = "1k2xh13miyv48gh06rgsq2vj25xwj7z6vwq9ilsn8i7ig3nrgzg4";
  };

  patches = [
    # Fix build on Apple Silicon. Remove in the next release.
    (fetchpatch {
      url = "https://github.com/festvox/speech_tools/commit/06141f69d21bf507a9becb5405265dc362edb0df.patch";
      hash = "sha256-tRestCBuRhak+2ccsB6mvDxGm/TIYX4eZ3oppCOEP9s=";
    })
  ];

  buildInputs = [
    ncurses
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    AudioUnit
    Cocoa
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "CXX=${stdenv.cc.targetPrefix}c++" ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: libestools.a(editline.o):(.bss+0x28): multiple definition of
  #     `editline_history_file'; libestools.a(siodeditline.o):(.data.rel.local+0x8): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )

    # c99 makes isnan valid for float and double
    substituteInPlace include/EST_math.h \
      --replace '__isnanf(X)' 'isnan(X)'
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,lib}
    for d in bin lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done
  '';

  doCheck = true;

  checkTarget = "test";

  meta = with lib; {
    description = "Text-to-speech engine";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.free;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.festvox.org/packed/festival/";
    };
  };
}
