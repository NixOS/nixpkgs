{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fk6icip2x1nh4kzhbc8cnqrs77avpqvj7ny3xadfh6yhn9aaw90";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
