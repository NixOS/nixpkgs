{ stdenv, pkgs, lib, buildPythonPackage, fetchPypi, six, enum34, decorator,
nose, shouldbe, gss, krb5Full, which, darwin }:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q6ccpz6anl9vggwxdq32wp6xjh2lyfbf7av6jqnmvmyqdfwh3b9";
  };

  LD_LIBRARY_PATH="${pkgs.krb5Full}/lib";

  buildInputs = [ krb5Full which nose shouldbe ]
  ++ ( if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.GSS ] else [ gss ] );

  propagatedBuildInputs =  [ decorator enum34 six ];

  doCheck = false; # No such file or directory: '/usr/sbin/kadmin.local'

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gssapi;
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
