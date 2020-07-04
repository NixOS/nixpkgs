{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-freezegun";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "060cdf192848e50a4a681a5e73f8b544c4ee5ebc1fab3cb7223a0097bac2f83f";
  };

  propagatedBuildInputs = [
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
