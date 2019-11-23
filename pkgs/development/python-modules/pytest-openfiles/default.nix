{ lib
, buildPythonPackage
, fetchPypi
, pytest
, psutil
}:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af591422f2bfa95f7690d83aeb8d76bd5421cb8b1dcaf085d58cd92e8d92058d";
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
