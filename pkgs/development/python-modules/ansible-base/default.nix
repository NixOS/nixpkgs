{ lib
, fetchPypi
, buildPythonPackage
, pycrypto
, paramiko
, jinja2
, pyyaml
, httplib2
, six
, netaddr
, dnspython
, jmespath
, dopy
, ncclient
, windowsSupport ? false
, pywinrm
, mock
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "ansible-base";
  version = "2.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ar2ks18hvf97fqi2hmv96xxmydf99i0hhkk46nnna1vw44f37y7";
  };

  prePatch = ''
    # ansible-connection is wrapped, so make sure it's not passed
    # through the python interpreter.
    sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py
  '';

  postInstall = ''
    for m in docs/man/man1/*; do
      install -vD $m -t $out/share/man/man1
    done
  '';

  propagatedBuildInputs = [
    pycrypto paramiko jinja2 pyyaml httplib2
    six netaddr dnspython jmespath dopy ncclient
  ] ++ lib.optional windowsSupport pywinrm;

  # requires ansible-test & docker
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.ansible.com";
    description = "Radically simple IT automation";
    license = [ licenses.gpl3 ] ;
    maintainers = with maintainers; [ joamaki costrouc hexa ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
