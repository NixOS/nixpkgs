{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1711gippwsl7c1wi8pc2y75xqq5sn1sscpqvrxjvpjm8pcx2138n";
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
