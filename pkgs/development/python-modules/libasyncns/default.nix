{ stdenv, buildPythonPackage, fetchurl
, libasyncns, pkgconfig }:

buildPythonPackage rec {
  pname = "libasyncns-python";
  name = "${pname}-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "https://launchpad.net/libasyncns-python/trunk/${version}/+download/libasyncns-python-${version}.tar.bz2";
    sha256 = "1q4l71b2h9q756x4pjynp6kczr2d8c1jvbdp982hf7xzv7w5gxqg";
  };

  patches = [ ./libasyncns-fix-res-consts.patch ];

  buildInputs = [ libasyncns ];
  nativeBuildInputs = [ pkgconfig ];
  doCheck = false; # requires network access

  meta = with stdenv.lib; {
    description = "libasyncns-python is a python binding for the asynchronous name service query library";
    license = licenses.lgpl21;
    maintainers = [ maintainers.mic92 ];
    homepage = https://launchpad.net/libasyncns-python;
  };
}
