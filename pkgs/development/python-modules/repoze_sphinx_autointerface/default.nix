{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze.sphinx.autointerface";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ef0383276ab722efb1e4a6523726262058dfd82615ccf7e5004aee3fe8ecc23";
  };

  propagatedBuildInputs = [ zope_interface sphinx ];

  meta = with stdenv.lib; {
    homepage = https://github.com/repoze/repoze.sphinx.autointerface;
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
