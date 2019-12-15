{ lib
, fetchFromGitHub
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
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "ansible";
    rev = "v${version}";
    sha256 = "08vqjk85j0g1x0iad03d7ysws433dikii8j2lr3a1mlx6d186vv8";
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
