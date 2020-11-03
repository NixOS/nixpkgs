{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-freezegun";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "19c82d5633751bf3ec92caa481fb5cffaac1787bd485f0df6436fd6242176949";
  };

  requiredPythonModules = [
    freezegun
    pytest
  ];

  meta = with lib; {
    description = "Wrap tests with fixtures in freeze_time";
    homepage = "https://github.com/ktosiek/pytest-freezegun";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
