{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel.ordereddict";
  version = "0.4.13";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf0a198c8ce5d973c24e5dba12d3abc254996788ca6ad8448eabc6aa710db149";
  };

  meta = with stdenv.lib; {
    description = "A version of dict that keeps keys in insertion resp. sorted order";
    homepage = https://bitbucket.org/ruamel/ordereddict;
    license = licenses.mit;
  };

}
