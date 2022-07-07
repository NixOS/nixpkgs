{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pytest-celery";
  version = "0.1.0";

  format = "flit";

  src = fetchFromGitHub {
    owner = "celery";
    repo = "pytest-celery";
    rev = "v${version}";
    sha256 = "sha256-vzWwkOS3BLOInaFDk+PegvEmC88ZZ1sG1CmHwhn7r9w=";
  };

  postPatch = ''
    # avoid infinite recursion with celery
    substituteInPlace pyproject.toml \
      --replace '"celery >= 4.4.0"' ""
  '';

  # This package has nothing to test or import.
  doCheck = false;

  meta = with lib; {
    description = "Pytest plugin to enable celery.contrib.pytest";
    homepage = "https://github.com/celery/pytest-celery";
    license = licenses.mit;
    maintainers = [ ];
  };
}
