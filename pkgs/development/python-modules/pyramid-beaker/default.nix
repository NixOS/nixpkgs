{ lib, buildPythonPackage, fetchPypi, pytest, beaker, pyramid }:

buildPythonPackage rec {
  pname = "pyramid-beaker";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hflx3qkcdml1mwpq53sz46s7jickpfn0zy0ns2c7j445j66bp3p";
  };

  checkPhase = ''
    # https://github.com/Pylons/pyramid-beaker/issues/29
    py.test -k 'not test_includeme' pyramid-beaker/tests.py
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ beaker pyramid ];

  meta = with lib; {
    description = "Beaker session factory backend for Pyramid";
    homepage = "https://docs.pylonsproject.org/projects/pyramid-beaker/en/latest/";
    # idk, see https://github.com/Pylons/pyramid-beaker/blob/master/LICENSE.txt
    # license = licenses.mpl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
