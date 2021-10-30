{ lib
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
, mock
, toml
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.9";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "951bd9a64731c444fd907a5ce268543020086a697f6be08f7cc2c9a752a278c5";
  };

  propagatedBuildInputs = [ ipython toml ];
  checkInputs = [ mock ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
