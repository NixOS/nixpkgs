{ lib
, buildPythonPackage
, fetchPypi
, pytest
, psutil
}:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e51c91889eb9e4c75f47735efc57a1435f3f1182463600ba7bce7f2556a46884";
  };

  propagatedBuildInputs = [
    pytest
    psutil
  ];

  checkInputs = [
    pytest
  ];

  postConfigure = ''
    # remove on next release
    substituteInPlace setup.cfg \
      --replace "[pytest]" "[tool:pytest]"
  '';

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pytest plugin for detecting inadvertent open file handles";
    homepage = https://astropy.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
