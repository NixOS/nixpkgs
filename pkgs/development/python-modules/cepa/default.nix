{ lib, buildPythonPackage, fetchPypi, python, mock }:

buildPythonPackage rec {
  pname = "cepa";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P7xwGsP8ic1/abxYptDXNbAU+kC2Hiwu/Tge0g21ipY=";
  };

  postPatch = ''
    rm test/unit/installation.py
    sed -i "/test.unit.installation/d" test/settings.cfg
    # https://github.com/torproject/stem/issues/56
    sed -i '/MOCK_VERSION/d' run_tests.py
  '';

  nativeCheckInputs = [ mock ];

  checkPhase = ''
    touch .gitignore
    ${python.interpreter} run_tests.py -u
  '';

  meta = with lib; {
    description = "Controller library that allows applications to interact with Tor";
    homepage = "https://github.com/onionshare/cepa";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ lourkeur ];
  };
}
