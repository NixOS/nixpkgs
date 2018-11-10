{ stdenv
, buildPythonPackage
, fetchPypi
, notebook
, pythonOlder
, texlive
}:

buildPythonPackage rec {
  pname = "jupyterlab_latex";
  version = "0.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1abd43f6d5b28f2c52164e80e6fe6ff93f0558472cbbac9927647a1887ee269";
  };

  passthru = {
    jupyterlabExtensions = [ "@jupyterlab/latex" ];
  };

  propagatedBuildInputs = [ notebook texlive.combined.scheme-full ];

  postPatch = ''
   touch LICENSE
  '';

  meta = with stdenv.lib; {
    description = "A Jupyter Notebook server extension which acts as an endpoint for LaTeX.";
    homepage = http://jupyter.org;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
