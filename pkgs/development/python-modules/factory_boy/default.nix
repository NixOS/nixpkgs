{ stdenv
, buildPythonPackage
, fetchPypi
, fake_factory
}:

buildPythonPackage rec {
  pname = "factory_boy";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a21f8kq917fj8xgmyp6gy8vcrlzzgwn80qas0d76h3vjbdy0bdq";
  };

  propagatedBuildInputs = [ fake_factory ];

  meta = with stdenv.lib; {
    description = "A Python package to create factories for complex objects";
    homepage    = https://github.com/rbarrois/factory_boy;
    license     = licenses.mit;
  };

}
