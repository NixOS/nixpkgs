{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, ipython
, jupyter_client
, traitlets
, tornado
, pythonOlder
, pytest
, nose
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "5.1.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc0bf97920d454102168ec2008620066878848fcfca06c22b669696212e292f";
  };

  checkInputs = [ pytest nose ];
  propagatedBuildInputs = [ ipython jupyter_client traitlets tornado ];

  # https://github.com/ipython/ipykernel/pull/377
  patches = [
    (fetchpatch {
      url = "https://github.com/ipython/ipykernel/commit/a3bf849dbd368a1826deb9dfc94c2bd3e5ed04fe.patch";
      sha256 = "1yhpwqixlf98a3n620z92mfips3riw6psijqnc5jgs2p58fgs2yc";
    })
  ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest ipykernel
  '';

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
