{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "json-c-0.12";
  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${name}-nodoc.tar.gz";
    sha256 = "0dgvjjyb9xva63l6sy70sdch2w4ryvacdmfd3fg2f2v13lqx5mkg";
  };

  patches = [ ./unused-variable.patch ];

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook ]; # won't configure without it, no idea why

  # compatibility hack (for mypaint at least)
  postInstall = ''
    ln -s json-c.pc "$dev/lib/pkgconfig/json.pc"
  '';

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
