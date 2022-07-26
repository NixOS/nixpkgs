{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, pytest
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2";
  };

  postPatch = ''
    sed -i "s/==.*//g" requirements/test.txt

    substituteInPlace requirements/base.txt --replace 'PyYAML>=3.13,<6' 'PyYAML>=3.13'
  '';

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Configuration manager for python applications";
    homepage = "https://kaptan.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
