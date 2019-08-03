{ stdenv, lib, buildPythonPackage, fetchPypi, six, enum34, decorator,
nose, gss, krb5Full, darwin }:

buildPythonPackage rec {
  pname = "gssapi";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76c9fda88a7178f41bf6454a06d64054c56b46f0dcbc73307f2e57bb8c25d8cc";
  };

  # It's used to locate headers
  postPatch = ''
    substituteInPlace setup.py \
      --replace "get_output('krb5-config gssapi --prefix')" "'${lib.getDev krb5Full}'"
  '';

  LD_LIBRARY_PATH = "${krb5Full}/lib";

  nativeBuildInputs = [ krb5Full ]
  ++ ( if stdenv.isDarwin then [ darwin.apple_sdk.frameworks.GSS ] else [ gss ] );

  propagatedBuildInputs =  [ decorator enum34 six ];

  checkInputs = [ nose ];

  doCheck = false; # No such file or directory: '/usr/sbin/kadmin.local'

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gssapi;
    description = "Python GSSAPI Wrapper";
    license = licenses.mit;
  };
}
