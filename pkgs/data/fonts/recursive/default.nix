{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "recursive";
  version = "1.022";

  srcs = [
    (fetchzip {
      name = "${pname}";
      url = "https://github.com/arrowtype/recursive/releases/download/v${version}/recursive-beta_1_022.zip";
      sha256 = "09nr1fli7ksv8z4yb25c4xidwsqq50av18qrybsy4kqy5c22957v";
      stripRoot = false;
    })

    (fetchzip {
      name = "${pname}-static";
      url = "https://github.com/arrowtype/recursive/releases/download/v${version}/recursive-static_fonts-b020.zip";
      sha256 = "1wlj113gjm26ra9y2r2b3syis2wx0mjq2m8i8xpwscp1kflma1r6";
      stripRoot = false;
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype,woff2}
    find -name "*.otf" -exec cp "{}" $out/share/fonts/opentype \;
    find -name "*.ttf" -exec cp "{}" $out/share/fonts/truetype \;
    find -name "*.woff2" -exec cp "{}" $out/share/fonts/woff2 \;
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/arrowtype/recursive;
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
