{ lib
, buildPythonPackage
, fetchPypi
, pytest
, psutil
}:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "179c2911d8aee3441fee051aba08e0d9b4dab61b829ae4811906d5c49a3b0a58";
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
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
