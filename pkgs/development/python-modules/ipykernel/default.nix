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
  version = "5.1.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "173nm29g85w8cac3fg40b27qaq26g41wgg6qn79ql1hq4w2n5sgh";
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

  # For failing tests, see https://github.com/ipython/ipykernel/issues/387
  checkPhase = ''
    HOME=$(mktemp -d) pytest ipykernel -k "not (test_sys_path or test_sys_path_profile_dir or test_complete)"
  '';

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
