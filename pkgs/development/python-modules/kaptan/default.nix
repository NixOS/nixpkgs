{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, pytest
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EBMwpE/e3oiFhvMBC9FFwOxIpIBrxWQp+lSHpndAIfg=";
  };

  postPatch = ''
    sed -i "s/==.*//g" requirements/test.txt

    substituteInPlace requirements/base.txt --replace 'PyYAML>=3.13,<6' 'PyYAML>=3.13'
  '';

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Configuration manager for python applications";
    homepage = "https://kaptan.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
