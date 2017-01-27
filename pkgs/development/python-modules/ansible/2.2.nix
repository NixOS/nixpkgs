{ lib
, fetchurl
, buildPythonPackage
, pycrypto
, paramiko
, jinja2
, pyyaml
, httplib2
, boto
, six
, netaddr
, dns
, pywinrm
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.2.1.0";
  name = "${pname}-${version}";


  src = fetchurl {
    url = "http://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "0gz9i30pdmkchi936ijy873k8di6fmf3v5rv551hxyf0hjkjx8b3";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = false;
  windowsSupport = true;

  propagatedBuildInputs = [ pycrypto paramiko jinja2 pyyaml httplib2
    boto six netaddr dns ] ++ lib.optional windowsSupport pywinrm;

  meta = {
    homepage = "http://www.ansible.com";
    description = "A simple automation tool";
    license = with lib.licenses; [ gpl3] ;
    maintainers = with lib.maintainers; [
      jgeerds
      joamaki
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}