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
  version = "0.13.11";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wjtnNvAf1Fhswuy+vfeaXrRUeWhT4c2PLtO3uR1KPpM=";
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
