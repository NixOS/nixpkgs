{ stdenv, buildPythonPackage, fetchPypi, pytest, beaker, pyramid }:

buildPythonPackage rec {
  pname = "pyramid_beaker";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hflx3qkcdml1mwpq53sz46s7jickpfn0zy0ns2c7j445j66bp3p";
  };

  checkPhase = ''
    # https://github.com/Pylons/pyramid_beaker/issues/29
    py.test -k 'not test_includeme' pyramid_beaker/tests.py
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ beaker pyramid ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}
