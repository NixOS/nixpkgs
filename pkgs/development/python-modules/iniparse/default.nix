{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "iniparse";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m60k46vr03x68jckachzsipav0bwhhnqb8715hm1cngs89fxhdb";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  # Does not install tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Accessing and Modifying INI files";
    homepage = "https://github.com/candlepin/python-iniparse";
    license = licenses.mit;
    maintainers = with maintainers; [ danbst ];
  };

}
