{ lib
, buildPythonPackage
, fetchPypi
, decorator
, appdirs
, six
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2017.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80f1bba4469d473c1b3969bc8e188c03bcc94d35807a889ceebbfc78e3208115";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    decorator
    appdirs
    six
    numpy
  ];

  checkPhase = ''
    py.test -k 'not test_persistent_dict'
  '';

  meta = {
    homepage = https://github.com/inducer/pytools/;
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
