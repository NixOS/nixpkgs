{ buildPythonPackage, fetchPypi, python
, plaster, PasteDeploy
, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "plaster_pastedeploy";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70a3185b2a3336996a26e9987968cf35e84cf13390b7e8a0a9a91eb8f6f85ba9";
  };

  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ plaster PasteDeploy ];
  checkInputs = [ pytest pytestcov ];
}
