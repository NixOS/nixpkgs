{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "recursive";
  version = "1.030";

  src = fetchzip {
    url = "https://github.com/arrowtype/recursive/releases/download/${version}/recursive-beta_1_030--statics.zip";
    sha256 = "1clds4ljiqdf0zc3b7nlna1w7kc23pc9gxdd5vwbgmz9xfvkam0f";
    stripRoot = false;
  };

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
