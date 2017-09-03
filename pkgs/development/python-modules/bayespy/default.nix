{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, nose, numpy, scipy
, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.10";
  name = "${pname}-${version}";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01cwd88ri29zy6qpvnqzljkgc44n7a17yijizr73blcnh4dz5n1w";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  # We have to move to some other directory, otherwise the tests are run on the
  # source package, not the installed package. Also, ignore the image comparison
  # tests as, for some reason, some of them didn't work.
  checkPhase = ''
    mkdir temp
    cd temp
    nosetests --ignore-files="test_plot.py" bayespy
  '';

  meta = with stdenv.lib; {
    homepage = http://www.bayespy.org;
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
