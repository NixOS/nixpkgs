{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, six
}:

buildPythonPackage rec {
  pname = "iniparse";
  version = "0.5";

  src = fetchFromGitHub {
     owner = "candlepin";
     repo = "python-iniparse";
     rev = "0.5";
     sha256 = "0sykrswby83gkcvnxh242m58ydz2idldkjhw8g8bb4m1ygphkpx2";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  propagatedBuildInputs = [ six ];

  # Does not install tests
  doCheck = false;

  meta = with lib; {
    description = "Accessing and Modifying INI files";
    homepage = "https://github.com/candlepin/python-iniparse";
    license = licenses.mit;
    maintainers = with maintainers; [ danbst ];
  };

}
