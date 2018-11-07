{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, ipydatawidgets
, ipywidgets
, pytest
, nbval
}:

buildPythonPackage rec {
  pname = "pythreejs";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa7b787f29006a89b8cc5450319756b92304317bb17d4125ccf89c51a3da3c5c";
  };

  passthru = {
    jupyterlabExtensions = [ "jupyter-threejs" ];
  };

  propagatedBuildInputs = [ numpy ipydatawidgets ipywidgets ];

  meta = with stdenv.lib; {
    description = "Interactive 3d graphics for the Jupyter notebook, using Three.js from Jupyter interactive widgets";
    homepage = https://github.com/jupyter-widgets/pythreejs;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
