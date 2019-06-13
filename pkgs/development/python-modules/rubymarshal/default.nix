{ stdenv, buildPythonPackage, fetchPypi, hypothesis }:

buildPythonPackage rec {
  pname = "rubymarshal";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "131lbc18s3rlmby2dpbvi4msz13gqw6xvx067mh4zcx9npygn9r2";
  };

  propagatedBuildInputs = [ hypothesis ];

  meta = with stdenv.lib; {
    homepage = https://github.com/d9pouces/RubyMarshal/;
    description = "Read and write Ruby-marshalled data";
    license = licenses.wtfpl;
    maintainers = [ maintainers.ryantm ];
  };
}
