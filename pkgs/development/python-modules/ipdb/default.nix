{ stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.12";
  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    sha256 = "dce2112557edfe759742ca2d0fee35c59c97b0cc7a05398b791079d78f1519ce";
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
