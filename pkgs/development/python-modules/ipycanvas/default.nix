{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, jupyter-packaging
, ipywidgets
, numpy
, pillow
}:

buildPythonPackage rec {
  pname = "ipycanvas";
  version = "0.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+cOUBoG8ODgzkPjEbqXYRF1uEcbaZITDfYnfWuHawTE=";
  };

  # We relax dependencies here instead of pulling in a patch because upstream
  # has released a new version using hatch-jupyter-builder, but it is not yet
  # trivial to upgrade to that.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab==3.*",' "" \
      --replace 'jupyter_packaging~=' 'jupyter_packaging>='
  '';

  nativeBuildInputs = [ jupyter-packaging ];

  propagatedBuildInputs = [ ipywidgets numpy pillow ];

  doCheck = false;  # tests are in Typescript and require `npx` and `chromium`
  pythonImportsCheck = [ "ipycanvas" ];

  meta = with lib; {
    description = "Expose the browser's Canvas API to IPython";
    homepage = "https://ipycanvas.readthedocs.io";
    changelog = "https://github.com/jupyter-widgets-contrib/ipycanvas/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
