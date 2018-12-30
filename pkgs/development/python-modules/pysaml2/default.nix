{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, repoze_who
, paste
, cryptography
, pycrypto
, pyopenssl
, ipaddress
, six
, cffi
, idna
, enum34
, pytz
, setuptools
, zope_interface
, dateutil
, requests
, pyasn1
, webob
, decorator
, pycparser
, defusedxml
, Mako
, pytest
, memcached
, pymongo
, mongodict
, pkgs
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y2iw1dddcvi13xjh3l52z1mvnrbc41ik9k4nn7lwj8x5kimnk9n";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2016-10127.patch";
      url = "https://sources.debian.net/data/main/p/python-pysaml2/3.0.0-5/debian/patches/fix-xxe-in-xml-parsing.patch";
      sha256 = "184lkwdayjqiahzsn4yp15parqpmphjsb1z7zwd636jvarxqgs2q";
    })
  ];

  propagatedBuildInputs = [ repoze_who paste cryptography pycrypto pyopenssl ipaddress six cffi idna enum34 pytz setuptools zope_interface dateutil requests pyasn1 webob decorator pycparser defusedxml ];
  buildInputs = [ Mako pytest memcached pymongo mongodict pkgs.xmlsec ];

  preConfigure = ''
    sed -i 's/pymongo==3.0.1/pymongo/' setup.py
  '';

  # 16 failed, 427 passed, 17 error in 88.85 seconds
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rohe/pysaml2";
    description = "Python implementation of SAML Version 2 Standard";
    license = licenses.asl20;
  };

}
