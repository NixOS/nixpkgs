{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, ipython
}:

buildPythonPackage rec {
  pname = "ipdbplugin";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdcd6bc1e995c3c2c4971ed95f207e680aa44980b716fa43fb675ff2dcc7894f";
  };

  propagatedBuildInputs = [ nose ipython ];

  meta = with stdenv.lib; {
    homepage = http://github.com/flavioamieiro/nose-ipdb/tree/master;
    description = "Nose plugin to use iPdb instead of Pdb when tests fail";
    license = licenses.lgpl2;
    maintainers = [ maintainers.costrouc ];
  };

}
