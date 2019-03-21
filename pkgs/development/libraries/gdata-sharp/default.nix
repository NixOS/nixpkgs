{ stdenv, fetchsvn, pkgconfig, mono, dotnetPackages }:

let
  newtonsoft-json = dotnetPackages.NewtonsoftJson;
in stdenv.mkDerivation rec {
  name = "gdata-sharp-${version}";
  version = "2.2.0.0";

  src = fetchsvn {
    url = "http://google-gdata.googlecode.com/svn/trunk/";
    rev = "1217";
    sha256 = "0b0rvgg3xsbbg2fdrpz0ywsy9rcahlyfskndaagd3yzm83gi6bhk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ mono newtonsoft-json ];

  sourceRoot = "svn-r1217/clients/cs";

  dontStrip = true;

  postPatch = ''
    sed -i -e 's#^\(DEFINES=.*\)\(.\)#\1 /r:third_party/Newtonsoft.Json.dll\2#' Makefile
    #             carriage return ^
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://code.google.com/archive/p/google-gdata/;

    description = "The Google Data APIs";
    longDescription = ''
      The Google Data APIs provide a simple protocol for reading and writing
      data on the web.
    '';

    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
