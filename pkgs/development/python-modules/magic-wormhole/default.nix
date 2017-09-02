{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, nettools
, glibcLocales
, autobahn
, cffi
, click
, hkdf
, pynacl
, spake2
, tqdm
, python
, mock
, ipaddress
, humanize
, pyopenssl
, service-identity
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.10.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55a423247faee7a0644d25f37760495978cd494ba0274fefd8cd1fad493954ee";
  };

  checkInputs = [ mock ];
  buildInputs = [ nettools glibcLocales ];
  propagatedBuildInputs = [ autobahn cffi click hkdf pynacl spake2 tqdm ipaddress humanize pyopenssl service-identity ];

  postPatch = ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
    sed -i -e "s|if (os.path.dirname(os.path.abspath(wormhole))|if not os.path.abspath(wormhole).startswith('/nix/store') and (os.path.dirname(os.path.abspath(wormhole))|" src/wormhole/test/test_scripts.py
    # XXX: disable one test due to warning:
    # setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    sed -i -e "s|def test_text_subprocess|def skip_test_text_subprocess|" src/wormhole/test/test_scripts.py
  '' + lib.optionalString (pythonAtLeast "3.3") ''
    sed -i -e 's|"ipaddress",||' setup.py
  '';

  checkPhase = ''
    export PATH="$PATH:$out/bin"
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    ${python.interpreter} -m wormhole.test.run_trial wormhole
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = https://github.com/warner/magic-wormhole;
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric ];
  };
}
