{ stdenv, lib, buildPythonPackage, fetchPypi, python
, attrs, enum34, hyperlink, incremental, six, twisted, typing, tubes, werkzeug, zope_interface
, hypothesis, treq
}:

buildPythonPackage rec {
  pname = "klein";
  version = "21.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mpydmz90d0n9dwa7mr6pgj5v0kczfs05ykssrasdq368dssw7ch";
  };

  propagatedBuildInputs = [ attrs enum34 hyperlink incremental six twisted typing tubes werkzeug zope_interface ];

  checkInputs = [ hypothesis treq ];

  checkPhase = ''
    ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES klein
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Klein Web Micro-Framework";
    homepage    = "https://github.com/twisted/klein";
    license     = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
