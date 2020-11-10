{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, irctokens
, pendulum
, python
}:

buildPythonPackage rec {
  pname = "ircstates";
  version = "0.11.3";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v8r6ma8gzvn5ym3xx9qlb0rc4l67pxr3z8njzk1ffxn1x3mxd3i";
  };

  patches = [
    (fetchpatch {
      name = "relax-pendulum-version.patch";
      url = "https://github.com/jesopo/ircstates/commit/f51f1b689e592020d1c91ccab6c03927aadb9f94.patch";
      sha256 = "0qbp3b9hlqbbx7b474q1mcgnzzzwcm4g89x26iqgmlgxzmv3y5xp";
    })
  ];

  propagatedBuildInputs = [
    irctokens
    pendulum
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  pythonImportsCheck = [ "ircstates" ];

  meta = with lib; {
    description = "sans-I/O IRC session state parsing library";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/ircstates";
    maintainers = with maintainers; [ hexa ];
  };
}
