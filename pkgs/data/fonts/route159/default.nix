{ stdenv,  fetchzip }:

let
  majorVersion = "1";
  minorVersion = "10";
  pname = "route159";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}_${majorVersion}${minorVersion}.zip";
  sha256 = "1nv5csg73arvvwpac7ylh4j9n0s3qp79rbv2s4jvs2bf6gqhsq7h";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A weighted sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
  };
}
