{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, mock }:

buildPythonPackage rec {
  pname = "backports.unittest_mock";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73df9093bc7a2cc8e7018d08d6983dc5bcb2a47d7e7e107b9e8d0711f1702ef8";
  };

  propagatedBuildInputs = [ mock ];

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Provides a function install() which makes the mock module";
    homepage = https://github.com/jaraco/backports.unittest_mock;
    license = licenses.mit;
  };
}
