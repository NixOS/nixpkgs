{ lib
, buildPythonPackage
, fetchPypi
, babel
, pytz
, nine
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qe/FTQ6YrHiVklP3HFG9HsT7Yny6we2+Ithcj2UFdp4=";
  };

  propagatedBuildInputs = [ babel pytz nine ];

  # Since the following commit included in version 0.9.1+, no tests are present
  # in the archive on PyPI.
  #
  #   https://github.com/jackrosenthal/kajiki/commit/fe97577d99d670fa5e43701f0a415d247316177b
  #
  doCheck = false;

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
