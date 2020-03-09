{ stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.0";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nbs9m2pqg4j10m7c31vyb8h7wy29d9s8kiv0k2igbr821k1y3xr";
  };

  propagatedBuildInputs = [ ipython ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
