{ lib, buildPythonPackage, fetchPypi
, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71b506d49d34e539cc3cfdb7ce2c5f072bea5c953320002c95968e0238f8ecf1";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ pytest ];

  meta = with lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
