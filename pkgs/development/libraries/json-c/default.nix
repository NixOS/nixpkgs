{ stdenv, fetchurl, autoconf }:

stdenv.mkDerivation rec {
  name = "json-c-0.13.1";
  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${name}-nodoc.tar.gz";
    sha256 = "0ch1v18wk703bpbyzj7h1mkwvsw4rw4qdwvgykscypvqq10678ll";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoconf ];  # for autoheader

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
