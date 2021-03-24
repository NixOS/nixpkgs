{ lib
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
, isPy27
, mock
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.7";
  disabled = isPyPy || isPy27;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "178c367a61c1039e44e17c56fcc4a6e7dc11b33561261382d419b6ddb4401810";
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
