{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, cogapp
, mock
, virtualenv
}:

buildPythonPackage rec {
  version = "1.2.2";
  pname   = "Paver";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lix9d33ndb3yk56sm1zlj80fbmxp0w60yk0d9pr2xqxiwi88sqy";
  };

  buildInputs = [ cogapp mock virtualenv ];

  propagatedBuildInputs = [ nose ];

  # the tests do not pass
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python-based build/distribution/deployment scripting tool";
    homepage    = https://github.com/paver/paver;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
