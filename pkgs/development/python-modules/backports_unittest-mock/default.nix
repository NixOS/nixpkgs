{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, mock }:

buildPythonPackage rec {
  pname = "backports.unittest_mock";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eff58e53de8fdeb27a1c87a9d57e7b91d15d1bc3854e85344b1a2e69f31ecda7";
  };

  propagatedBuildInputs = [ mock ];

  buildInputs = [ setuptools_scm ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "backports.unittest_mock" ];

  meta = with stdenv.lib; {
    description = "Provides a function install() which makes the mock module";
    homepage = "https://github.com/jaraco/backports.unittest_mock";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
