{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "interruptingcow";
  version = "0.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j6d0rbh8xjfw7bf8vcjld6q45i7vr9xsw5b9q6j87nhf4qhzx53";
  };

  meta = with stdenv.lib; {
    description = "A watchdog that interrupts long running code";
    homepage = https://bitbucket.org/evzijst/interruptingcow;
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
  };
}
