{ stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.12.2";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mzfv2sa8qabqzh2vqgwhavb15gsmcgqn6i3jgq6b5q9i9wxsgs7";
  };

  propagatedBuildInputs = [ ipython ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gotcha/ipdb;
    description = "IPython-enabled pdb";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
