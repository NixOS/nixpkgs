{ stdenv
, buildPythonPackage
, fetchPypi
, six
, matplotlib
, ipywidgets
, ipykernel
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48ede51641bee78c32994cbd86b385714d61beb7d80c87f0cc1b70efb51dd5f5";
  };

  passthru = {
    jupyterlabExtensions = [ "jupyter-matplotlib" "@jupyter-widgets/jupyterlab-manager" ];
  };

  propagatedBuildInputs = [ six matplotlib ipywidgets ipykernel ];

  meta = with stdenv.lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = http://matplotlib.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
