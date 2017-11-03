{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, mock }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "backports.unittest_mock";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xdkx5wf5a2w2zd2pshk7z2cvbv6db64c1x6v9v1a18ja7bn9nf6";
  };

  propagatedBuildInputs = [ mock ];

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Provides a function install() which makes the mock module";
    homepage = https://github.com/jaraco/backports.unittest_mock;
    license = licenses.mit;
  };
}
