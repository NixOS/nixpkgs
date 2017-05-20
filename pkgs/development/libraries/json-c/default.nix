{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "json-c-0.12.1";
  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${name}-nodoc.tar.gz";
    sha256 = "148jkvpnxmg1fwwigp0nq9qbd5vzpnmgiw3y34w7k6fymalpsqas";
  };

  outputs = [ "out" "dev" ];

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
