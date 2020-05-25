{ stdenv, buildPythonPackage, fetchPypi, hypothesis, isPy3k }:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.2.6";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gq344jlb9wkapzpxj7jqwjlc5ccdhhspkw6rfb1d0rammq6hpf6";
  };

  propagatedBuildInputs = [ hypothesis ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/d9pouces/RubyMarshal/";
    description = "Read and write Ruby-marshalled data";
    license = licenses.wtfpl;
    maintainers = [ maintainers.ryantm ];
  };
}
