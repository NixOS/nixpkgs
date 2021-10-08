{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pyyaml
, packaging
, pytest
, flaky
, pytest-mock
}:

buildPythonPackage rec {
  pname = "ansible-compat";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x856ia1fkj8agiswwnz5nwv8cvbkjnsnk2a4ks1j3bi6axznc07";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    pytest
    pytest-mock
    flaky
    packaging
  ];

  meta = with lib; {
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ilpianista ]; # if you're ok with it
  };
}

