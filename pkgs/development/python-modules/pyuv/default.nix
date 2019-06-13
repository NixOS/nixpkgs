{ stdenv
, buildPythonPackage
, fetchurl
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "pyuv";
  version = "1.2.0";
  disabled = isPyPy;  # see https://github.com/saghul/pyuv/issues/49

  src = pkgs.fetchurl {
    url = "https://github.com/saghul/pyuv/archive/${pname}-${version}.tar.gz";
    sha256 = "19yl1l5l6dq1xr8xcv6dhx1avm350nr4v2358iggcx4ma631rycx";
  };

  patches = [ ./pyuv-external-libuv.patch ];

  buildInputs = [ pkgs.libuv ];

  meta = with stdenv.lib; {
    description = "Python interface for libuv";
    homepage = https://github.com/saghul/pyuv;
    repositories.git = git://github.com/saghul/pyuv.git;
    license = licenses.mit;
  };

}
