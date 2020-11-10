{ stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.3";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y3yk5k2yszcwxsjinvf40b1wl8wi8l6kv7pl9jmx9j53hk6vx6n";
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
