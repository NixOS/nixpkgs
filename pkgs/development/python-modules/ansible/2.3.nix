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
, windowsSupport ? false
, pywinrm ? null
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.3.1.0";
  name = "${pname}-${version}";


  src = fetchurl {
    url = "http://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "1xdr82fy8gahxh3586wm5k1bxksys7yl1f2n24shrk8gf99qyjyd";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = false;

  propagatedBuildInputs = [ pycrypto paramiko jinja2 pyyaml httplib2
    boto six netaddr dns ] ++ lib.optional windowsSupport pywinrm;

  meta = {
    homepage = http://www.ansible.com;
    description = "A simple automation tool";
    license = with lib.licenses; [ gpl3] ;
    maintainers = with lib.maintainers; [
      jgeerds
      joamaki
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
