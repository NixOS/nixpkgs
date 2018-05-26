{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lamywk6dm5xshlkdvxxf5j6fa2k2zpi7xagf0bwidaay3vnpgb2";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
