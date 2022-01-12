{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dnspythonchia";
  version = "2.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iYaPYqOZ33R2DUXgIHxsewLi79iB5ja0WHOGkamffZk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # needs networking for some tests
  doCheck = false;
  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "A DNS toolkit for Python (Chia Network fork)";
    homepage = "https://www.chia.net/";
    license = with licenses; [ isc ];
    maintainers = teams.chia.members;
  };
}
