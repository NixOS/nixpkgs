{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  dnspython,
  chardet,
  lmtpd,
  python-daemon,
  six,
  jinja2,
  mock,
  click,
}:

buildPythonPackage rec {
  pname = "salmon-mail";
  version = "3.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3UFXkKlDWcm7ZUpdiiTXW4r5msNiX5wN2fisEHM3VWA=";
  };

  nativeCheckInputs = [
    jinja2
    mock
  ];
  propagatedBuildInputs = [
    chardet
    dnspython
    lmtpd
    python-daemon
    six
    click
  ];

  # Darwin tests fail without this. See:
  # https://github.com/NixOS/nixpkgs/pull/82166#discussion_r399909846
  __darwinAllowLocalNetworking = true;

  # The tests use salmon executable installed by salmon itself so we need to add
  # that to PATH
  checkPhase = ''
    # tests fail and pytest is not supported
    rm tests/server_tests.py
    PATH=$out/bin:$PATH python setup.py test
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://salmon-mail.readthedocs.org/";
    description = "Pythonic mail application server";
    mainProgram = "salmon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
  };
}
