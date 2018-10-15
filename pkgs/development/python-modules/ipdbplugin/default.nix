{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, ipython
}:

buildPythonPackage rec {
  pname = "ipdbplugin";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4778d78b5d0af1a2a6d341aed9e72eb73b1df6b179e145b4845d3a209137029c";
  };

  propagatedBuildInputs = [ nose ipython ];

  meta = with stdenv.lib; {
    homepage = http://github.com/flavioamieiro/nose-ipdb/tree/master;
    description = "Nose plugin to use iPdb instead of Pdb when tests fail";
    license = licenses.lgpl2;
    maintainers = [ maintainers.costrouc ];
  };

}
