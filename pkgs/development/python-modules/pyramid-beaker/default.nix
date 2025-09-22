{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  beaker,
  pyramid,
}:

buildPythonPackage rec {
  pname = "pyramid-beaker";
  version = "0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "pyramid_beaker";
    inherit version;
    hash = "sha256-zMUT60z7W0Flfym25rKMor17O/n9qRMGoQKa7pLRz6U=";
  };

  checkPhase = ''
    # https://github.com/Pylons/pyramid_beaker/issues/29
    py.test -k 'not test_includeme' pyramid_beaker/tests.py
  '';

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [
    beaker
    pyramid
  ];

  meta = with lib; {
    description = "Beaker session factory backend for Pyramid";
    homepage = "https://docs.pylonsproject.org/projects/pyramid_beaker/en/latest/";
    # idk, see https://github.com/Pylons/pyramid_beaker/blob/master/LICENSE.txt
    # license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
