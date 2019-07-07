{ stdenv
, buildPythonPackage
, fetchPypi
, repoze_lru
, six
, webob
, coverage
, webtest
}:

buildPythonPackage rec {
  pname = "Routes";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zamff3m0kc4vyfniyhxpkkcqv1rrgnmh37ykxv34nna1ws47vi6";
  };

  propagatedBuildInputs = [ repoze_lru six webob ];
  checkInputs = [ coverage webtest ];

  meta = with stdenv.lib; {
    description = "A Python re-implementation of the Rails routes system for mapping URLs to application actions";
    homepage = http://routes.groovie.org/;
    license = licenses.mit;
  };

}
