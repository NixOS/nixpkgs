{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "ibis";
  version = "1.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "dmulholl";
    repo = pname;
    rev = version;
    sha256 = "0xqhk397gzanvj2znwcgy4n5l1lc9r310smxkhjbm1xwvawpixx0";
  };

  checkPhase = ''
    ${python.interpreter} test_ibis.py
  '';

  meta = with lib; {
    description = "A lightweight template engine";
    homepage = https://github.com/dmulholland/ibis;
    license = licenses.publicDomain;
    maintainers = [ maintainers.costrouc ];
  };
}
