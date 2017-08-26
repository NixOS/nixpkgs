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

let
  # Shouldn't be needed anymore in next version
  # https://github.com/NixOS/nixpkgs/pull/22345#commitcomment-20718521
  jinja = (jinja2.override rec {
    pname = "Jinja2";
    version = "2.8.1";
    name = "${pname}-${version}";
    src = fetchurl {
      url = "mirror://pypi/J/Jinja2/${name}.tar.gz";
      sha256 = "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891";
    };
  });
in buildPythonPackage rec {
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

  propagatedBuildInputs = [ pycrypto paramiko jinja pyyaml httplib2
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
