{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2019.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bnpw7hrf9i1l9gfxjnzi45hkrvzz0pyn9ia8m4mw7sxhgb08qdj";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}
