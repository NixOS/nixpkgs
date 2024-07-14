{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  flake8,
}:

buildPythonPackage rec {
  pname = "getkey";
  version = "0.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aMfHAsOzTerPQn9sDx/WbFwqoS14AaoyRC/BpxyM4Fk=";
  };

  # disable coverage, because we don't care and python-coveralls is not in nixpkgs
  postPatch = ''
    sed -e '/python-coveralls/d' -e '/pytest-cov/d' -i setup.py
    rm setup.cfg
  '';

  nativeCheckInputs = [
    flake8
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Read single characters and key-strokes";
    homepage = "https://github.com/kcsaff/getkey";
    license = licenses.mit;
    maintainers = [ maintainers.symphorien ];
  };
}
