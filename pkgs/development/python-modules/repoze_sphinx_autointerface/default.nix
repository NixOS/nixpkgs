{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze.sphinx.autointerface";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97ef5fac0ab0a96f1578017f04aea448651fa9f063fc43393a8253bff8d8d504";
  };

  propagatedBuildInputs = [ zope_interface sphinx ];

  meta = with stdenv.lib; {
    homepage = https://github.com/repoze/repoze.sphinx.autointerface;
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
