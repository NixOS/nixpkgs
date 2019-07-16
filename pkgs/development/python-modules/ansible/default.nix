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
  version = "2.8.2";

  src = fetchurl {
    url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
    sha256 = "1e5ba829ca0602c55b33da399b06f99b135a34014b661d1c36d8892a1e2d3730";
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
