{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-crum";
  version = "0.7.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zem8DwcKZj+vxNnjV/Rf1ObwGDiyCp4vt2cPVwZ1Qog=";
  };

  build-system = [ setuptools ];

  # setup.cfg's [options] setup_requires pulls in pytest-runner and
  # setuptools-twine, both only used for its own `test`/`ship_it` dev
  # commands (not present in nixpkgs, setuptools-twine isn't packaged
  # anywhere). Strip it so pypaBuildPhase's dependency resolution doesn't
  # try to satisfy build-time-only tooling irrelevant to the wheel itself.
  postPatch = ''
    sed -i '/^setup_requires =/,/^tests_require =/{/^setup_requires =/d; /^tests_require =/!d}' setup.cfg
  '';

  dependencies = [ django ];

  # setup.cfg's [tool:pytest] addopts hardcodes --flake8 --cov ... (needs
  # pytest-flake8, unpackaged/abandoned) and testpaths needs a full Django
  # test_project settings module. Not worth wiring up for a small current-
  # user middleware; pythonImportsCheck below is enough coverage.
  doCheck = false;

  pythonImportsCheck = [ "crum" ];

  meta = {
    description = "Current Authenticated User Middleware for Django";
    homepage = "https://github.com/ninemoreminutes/django-crum";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
