{ lib, fetchFromGitHub, buildPythonPackage,
  tkinter, xmlschema, docutils, pygments, pyyaml, enum34, enum-compat, pillow, lxml, jsonschema,
  python }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-c7pPcDgqyqWQtiMbLQbQd0nAgx4TIFUFHrlBVDNdr8M=";
  };

  propagatedBuildInputs = [ tkinter xmlschema docutils pygments pyyaml enum34 enum-compat pillow lxml ];

  checkInputs = [ jsonschema ];

  checkPhase = ''
    python3 utest/run.py
  '';

  meta = with lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
