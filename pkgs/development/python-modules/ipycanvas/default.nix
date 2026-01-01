{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  ipywidgets,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "ipycanvas";
<<<<<<< HEAD
  version = "0.14.2";
=======
  version = "0.14.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-OFNwRHcRlN2jFjbEEHh4RxZyp6y1hLfotRgrIpsXBtU=";
=======
    hash = "sha256-kh8UgiWLWSm1mTF7XBKZMdgOFr41+jgwCjLnqkz+n4k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # We relax dependencies here instead of pulling in a patch because upstream
  # has released a new version using hatch-jupyter-builder, but it is not yet
  # trivial to upgrade to that.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"jupyterlab>=3,<5",' "" \
  '';

  build-system = [ hatchling ];

  env.HATCH_BUILD_NO_HOOKS = true;

  dependencies = [
    ipywidgets
    numpy
    pillow
  ];

  doCheck = false; # tests are in Typescript and require `npx` and `chromium`
  pythonImportsCheck = [ "ipycanvas" ];

<<<<<<< HEAD
  meta = {
    description = "Expose the browser's Canvas API to IPython";
    homepage = "https://ipycanvas.readthedocs.io";
    changelog = "https://github.com/jupyter-widgets-contrib/ipycanvas/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
=======
  meta = with lib; {
    description = "Expose the browser's Canvas API to IPython";
    homepage = "https://ipycanvas.readthedocs.io";
    changelog = "https://github.com/jupyter-widgets-contrib/ipycanvas/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
