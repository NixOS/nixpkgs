{ stdenv
, buildPythonPackage
, fetchPypi
, psutil
, notebook
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "jupyterlab_git";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a58655019ee5d1f5849d27ac69f3b518bfb5920466a8b68b9ca246d1070e8d4";
  };

  passthru = {
    jupyterlabExtensions = [ "@jupyterlab/git" ];
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ psutil notebook ];

  meta = with stdenv.lib; {
    description = "A server extension for JupyterLab's git extension";
    homepage = https://github.com/jupyterlab/jupyterlab-git;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
