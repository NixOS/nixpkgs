{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
, spake2
, pynacl
, six
, attrs
, twisted
, autobahn
, automat
, hkdf
, tqdm
, click
, humanize
, ipaddress
, txtorcon
, nettools
, glibc
, glibcLocales
, mock
, magic-wormhole-transit-relay
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9558ea1f3551e535deec3462cd5c8391cb32ebb12ecd8b40b36861dbee4917ee";
  };

  checkInputs = [ mock magic-wormhole-transit-relay ];
  buildInputs = [ nettools glibcLocales ];
  propagatedBuildInputs = [ spake2 pynacl six attrs twisted autobahn automat hkdf tqdm click humanize ipaddress txtorcon ];

  postPatch = ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
    sed -i -e "s|if (os.path.dirname(os.path.abspath(wormhole))|if not os.path.abspath(wormhole).startswith('/nix/store') and (os.path.dirname(os.path.abspath(wormhole))|" src/wormhole/test/test_cli.py

    # magic-wormhole will attempt to find all available locales by running
    # 'locale -a'.  If we're building on Linux, then this may result in us
    # running the system's locale binary instead of the one from Nix, so let's
    # ensure we patch this.
    sed -i -e 's|getProcessOutputAndValue("locale"|getProcessOutputAndValue("${glibc}/bin/locale"|' src/wormhole/test/test_cli.py
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
