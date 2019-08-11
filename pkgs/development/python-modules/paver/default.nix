{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, cogapp
, mock
, virtualenv
}:

buildPythonPackage rec {
  version = "1.3.4";
  pname   = "Paver";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3e6498881485ab750efe40c5278982a9343bc627e137b11adced627719308c7";
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
