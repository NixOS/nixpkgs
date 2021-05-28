{ stdenv, fetchurl, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  name = "json-c-0.14";
  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${name}-nodoc.tar.gz";
    sha256 = "1yia8417qljmczs9w3rn4c4i2p2iywq098pgrj11s81599j4x4cr";
  };

  patches = [
    # https://nvd.nist.gov/vuln/detail/CVE-2020-12762
    (fetchpatch {
      name = "CVE-2020-12762.patch";
      url = "https://github.com/json-c/json-c/commit/5d6fa331418d49f1bd488553fd1cfa9ab023fabb.patch";
      sha256 = "0aar7kgbycqxnhh0lrr61adfbb903nbapalhs5i6h8anxwy1ylcm";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

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
