{ stdenv
, buildPythonPackage
, fetchPypi
, blockdiag
}:

buildPythonPackage rec {
  pname = "blockdiagcontrib-cisco";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06iw3q1w4g3lbgcmyz8m93rv0pfnk2gp8k83rs9ir671ym99gwr2";
  };

  buildInputs = [ blockdiag ];

  meta = with stdenv.lib; {
    description = "Noderenderer plugin for blockdiag containing Cisco networking symbols";
    homepage = "https://bitbucket.org/blockdiag/blockdiag-contrib/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.psfl;
  };

}
