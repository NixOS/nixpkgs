{ stdenv, fetchFromGitHub, libyaml }:

stdenv.mkDerivation rec {
  pname = "libcyaml";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h5ydyqdl8kzh526np3jsi0pm7ks16nh1hjkdsjcd6pacw7y6i6z";
  };

  buildInputs = [
    libyaml
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "C library for reading and writing YAML";
    homepage = "https://github.com/tlsa/libcyaml";
    license = licenses.isc;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
