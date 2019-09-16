{ stdenv, buildPythonPackage, fetchPypi, hypothesis }:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gq344jlb9wkapzpxj7jqwjlc5ccdhhspkw6rfb1d0rammq6hpf6";
  };

  propagatedBuildInputs = [ hypothesis ];

  meta = with stdenv.lib; {
    homepage = https://github.com/d9pouces/RubyMarshal/;
    description = "Read and write Ruby-marshalled data";
    license = licenses.wtfpl;
    maintainers = [ maintainers.ryantm ];
  };
}
