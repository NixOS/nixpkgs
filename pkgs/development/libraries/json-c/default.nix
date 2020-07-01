{ stdenv, fetchurl, fetchpatch, autoconf }:

stdenv.mkDerivation rec {
  name = "json-c-0.13.1";
  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${name}-nodoc.tar.gz";
    sha256 = "0ch1v18wk703bpbyzj7h1mkwvsw4rw4qdwvgykscypvqq10678ll";
  };

  patches = [
    # https://nvd.nist.gov/vuln/detail/CVE-2020-12762
    (fetchpatch {
      name = "CVE-2020-12762.patch";
      url = "https://github.com/json-c/json-c/commit/865b5a65199973bb63dff8e47a2f57e04fec9736.patch";
      sha256 = "1g5afk4khhm1sb70xrva1pyznshcw3ipzp1g5z60dpzxy303pp6h";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoconf ];  # for autoheader

  meta = with stdenv.lib; {
    description = "A JSON implementation in C";
    homepage    = "https://github.com/json-c/json-c/wiki";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license = licenses.mit;

    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
  };
}
