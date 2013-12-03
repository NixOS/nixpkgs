{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "json-c-0.9";
  src = fetchurl {
    url = "http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz";
    sha256 = "0xcl8cwzm860f8m0cdzyw6slwcddni4mraw4shvr3qgqkdn4hakh";
  };
  meta = with stdenv.lib; {
    homepage = "http://oss.metaparadigm.com/json-c/";
    description = "A JSON implementation in C";
    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
    platforms = platforms.linux;
  };
}
