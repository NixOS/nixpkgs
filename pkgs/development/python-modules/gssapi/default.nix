{ stdenv, pkgs, lib, buildPythonPackage, fetchPypi, six, enum34, decorator,
nose, shouldbe, gss, krb5Full, which, darwin }:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be715cb74ac56db2dd888b016097aaa29ab7d7d34c1f8c706ff63f76b3553f71";
  };

  # It's used to locate headers
  postPatch = ''
    substituteInPlace setup.py \
      --replace "get_output('krb5-config gssapi --prefix')" "'${lib.getDev krb5Full}'"
  '';

  LD_LIBRARY_PATH = "${pkgs.krb5Full}/lib";

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
