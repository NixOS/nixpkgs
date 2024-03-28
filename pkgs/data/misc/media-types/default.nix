{ lib, stdenv, fetchFromGitLab, nixosTests }:

stdenv.mkDerivation rec {
  pname = "media-types";
  version = "10.1.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = pname;
    rev = version;
    hash = "sha256-vLQHjHrYShEBf4Py0vjpugbfY8HHnIIrmnxIDjHu5g8=";
  };

  outputs = [ "out" "doc" ];

  installPhase = ''
    # Replace tabs symbols
    substituteInPlace ./mime.types \
      --replace "					" "  " \
      --replace "				" "  " \
      --replace "			" "  " \
      --replace "		" "  " \
      --replace "	" "  " \

    # Compatibility mode
    # See here for more information:
    # https://trac.nginx.org/nginx/ticket/1407
    substituteInPlace mime.types \
      --replace "text/javascript  es js mjs" "application/javascript  es js mjs" \
      --replace "application/xml  xml" "text/xml  xml"

    # Replace mime-type with recommended ones.
    substituteInPlace mime.types \
      --replace "application/x-rss+xml  rss" "application/rss+xml  rss" \
      --replace "image/vnd.microsoft.icon  ico" "image/x-icon  ico"

    # Add missing mime-types and extensions
    # Some of these mime-types are present only in the nginx package
    substituteInPlace mime.types \
      --replace "application/java-archive  jar" "application/java-archive  jar war ear" \
      --replace "application/octet-stream    bin deploy msu msp" "application/octet-stream    bin deploy img msu msp" \
      --replace "audio/aac  adts aac ass" "audio/aac  adts aac" \
      --replace "text/plain  txt text pot brf srt" "text/plain  txt text pot brf less"
    echo "application/x-cocoa  cco" >> ./mime.types
    echo "application/x-java-archive-diff  jardiff" >> ./mime.types
    echo "application/x-makeself  run" >> ./mime.types
    echo "application/x-ssa  ass ssa" >> ./mime.types
    echo "application/x-subrip  srt" >> ./mime.types
    echo "application/x-web-app-manifest+json  webapp" >> ./mime.types
    echo "audio/midi  midi kar" >> ./mime.types
    echo "text/vnd.rim.location.xloc  xloc" >> ./mime.types
    echo "video/mp2t  bdmv clpi cpi m2t m2ts mpl mpls" >> ./mime.types

    # Generate nginx mime-types
    echo "types {" > ./nginx-mime.types
    cat mime.types | sed -e '/^#.*/d' -e '/^$/d' -e 's/.*/\ \ &;/' -ne '/[^[:space:]][[:space:]]\{1,\}[^[:space:]]/p' >> ./nginx-mime.types
    echo "}" >> ./nginx-mime.types

    # Remove duplicate mime-types extensions
    substituteInPlace ./nginx-mime.types \
      --replace "application/x-maker  frm maker frame fm fb book fbdoc;" \
                "application/x-maker  maker frame fb book fbdoc;" \
      --replace "application/x-qgis  qgs shp shx;" \
                "application/x-qgis  qgs;" \
      --replace "application/x-scilab  sci sce;" \
                "application/x-scilab  sci;" \
      --replace "audio/AMR  amr AMR;" \
                "audio/AMR  amr;" \
      --replace "audio/AMR-WB  awb AWB;" \
                "audio/AMR-WB  awb;" \
      --replace "audio/EVRC-QCP  qcp QCP;" \
                "audio/EVRC-QCP  qcp;" \
      --replace "chemical/x-mdl-sdfile  sd sdf;" \
                "chemical/x-mdl-sdfile  sd;" \
      --replace "chemical/x-mopac-input  mop mopcrt mpc zmt;" \
                "chemical/x-mopac-input  mop mopcrt zmt;" \
      --replace "chemical/x-ncbi-asn1-binary  val aso;" \
                "chemical/x-ncbi-asn1-binary  val;"\
      --replace "image/j2c  j2c J2C j2k J2K;" \
                "image/j2c  j2c j2k;" \
      --replace "image/vnd.globalgraphics.pgb  PGB pgb;" \
                "image/vnd.globalgraphics.pgb  pgb;" \
      --replace "text/x-tcl  tcl tk;" \
                "text/x-tcl  tk;"

    sed -i ./nginx-mime.types \
      -e '/application\/mac-compactpro  .*/d' \
      -e '/audio\/x-gsm  .*/d' \
      -e '/chemical\/x-chemdraw  .*/d' \
      -e '/chemical\/x-cif  .*/d' \
      -e '/chemical\/x-cml  .*/d' \
      -e '/chemical\/x-ncbi-asn1-spec  .*/d' \
      -e '/chemical\/x-pdb  .*/d' \
      -e '/image\/x-jg  .*/d' \
      -e '/text\/x-csh  .*/d' \
      -e '/text\/x-sh  .*/d'

    install -D -m0444 mime.types $out/etc/mime.types
    install -D -m0444 nginx-mime.types $out/etc/nginx/mime.types
    install -D -m0444 debian/bug-presubj $doc/share/doc/media-types/presubj
    install -D -m0444 debian/changelog $doc/share/doc/media-types/changelog
    install -D -m0444 debian/copyright $doc/share/doc/media-types/copyright
  '';

  passthru = {
    tests.nginx-media-types = nixosTests.nginx-media-types;
  };

  meta = with lib; {
    description = "List of standard media types and their usual file extension";
    homepage = "https://salsa.debian.org/debian/media-types";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
