{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "characteristic";
  version = "14.3.0";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ded68d4e424115ed44e5c83c2a901a0b6157a959079d7591d92106ffd3ada380";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "Python attributes without boilerplate";
    homepage = https://characteristic.readthedocs.org;
  };
}
