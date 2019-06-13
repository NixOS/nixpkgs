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
, dnspython
, jmespath
, dopy
, windowsSupport ? false
, pywinrm
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.8.1";

  src = fetchurl {
    url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
    sha256 = "0ia4x17ywym3r1m96ar4h0wc2xlylhbjp6x4wzwkh4p2i0x1vmg1";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  postInstall = ''
    for m in docs/man/man1/*; do
      install -vD $m -t $out/share/man/man1
    done
  '';

  propagatedBuildInputs = [
    pycrypto paramiko jinja2 pyyaml httplib2 boto
    six netaddr dnspython jmespath dopy
  ] ++ lib.optional windowsSupport pywinrm;

  # dificult to test
  doCheck = false;

  meta = with lib; {
    homepage = http://www.ansible.com;
    description = "Radically simple IT automation";
    license = [ licenses.gpl3 ] ;
    maintainers = with maintainers; [ joamaki costrouc ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
