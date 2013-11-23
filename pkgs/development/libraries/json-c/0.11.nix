{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "json-c-0.11";
  src = fetchurl {
    url    = "https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz";
    sha256 = "1m8fy7lbahv1r7yqbhw4pl057sxmmgjihm1fsvc3h66710s2i24r";
  };
  meta = with stdenv.lib; {
    description = "A JSON implementation in C";
    homepage    = https://github.com/json-c/json-c/wiki;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
  };
}
