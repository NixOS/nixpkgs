{ stdenv, buildPythonPackage, fetchPypi, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c1bf26431a3b487940cd4a7c0eefde328f5ff7098222ee695805752dae94aa6";
  };

  propagatedBuildInputs = [ unittest2 six ];

  # package supports 3.x but tests require egenix-mx-base which is python 2.x only
  # and is not currently in nixos
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python packages and modules used by Logilab ";
    homepage = https://www.logilab.org/project/logilab-common;
    license = licenses.lgpl21;
  };
}
