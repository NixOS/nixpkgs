{ lib, stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
, isPy27
, mock
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.4";
  disabled = isPyPy || isPy27;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "c85398b5fb82f82399fc38c44fe3532c0dde1754abee727d8f5cfcc74547b334";
  };

  propagatedBuildInputs = [ ipython ];
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
