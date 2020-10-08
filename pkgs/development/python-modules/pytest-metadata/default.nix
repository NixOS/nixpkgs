{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0593jf8l30ayrqr9gkmwfbhz9h8cyqp7mgwp7ah1gjysbajf1rmp";
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
