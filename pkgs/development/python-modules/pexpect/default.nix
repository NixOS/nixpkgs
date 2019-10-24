{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
}:

buildPythonPackage rec {
  pname = "pexpect";
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e2c1fd0e6ee3a49b28f95d4b33bc389c89b20af6a1255906e90ff1262ce62eb";
  };

  # Wants to run pythonin a subprocess
  doCheck = false;

  propagatedBuildInputs = [ ptyprocess ];

  meta = with lib; {
    homepage = http://www.noah.org/wiki/Pexpect;
    description = "Automate interactive console applications such as ssh, ftp, etc";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];

    longDescription = ''
      Pexpect is similar to the Don Libes "Expect" system, but Pexpect
      as a different interface that is easier to understand. Pexpect
      is basically a pattern matching system. It runs programs and
      watches output. When output matches a given pattern Pexpect can
      respond as if a human were typing responses. Pexpect can be used
      for automation, testing, and screen scraping. Pexpect can be
      used for automating interactive console applications such as
      ssh, ftp, passwd, telnet, etc. It can also be used to control
      web applications via "lynx", "w3m", or some other text-based web
      browser. Pexpect is pure Python. Unlike other Expect-like
      modules for Python Pexpect does not require TCL or Expect nor
      does it require C extensions to be compiled. It should work on
      any platform that supports the standard Python pty module.
    '';
  };
}
