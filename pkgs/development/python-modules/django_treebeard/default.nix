{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c21db06a8d4943bf2a28d9d7a119058698fb76116df2679ecbf15a46a501de42";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ django ];

  # tests fail  "AppRegistryNotReady("Apps aren't loaded yet.")"
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Efficient tree implementations for Django 1.6+";
    homepage = https://tabo.pe/projects/django-treebeard/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.asl20;
  };

}
