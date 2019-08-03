{ stdenv, buildPythonPackage, fetchFromGitHub, pyparsing }:

buildPythonPackage rec {
  pname = "asn1ate";
  version= "0.6";

  src = fetchFromGitHub {
    sha256 = "1p8hv4gsyqsdr0gafcq497n52pybiqmc22di8ai4nsj60fv0km45";
    rev = "v${version}";
    owner = "kimgr";
    repo = pname;
  };

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python library for translating ASN.1 into other forms";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leenaars ];
  };
}
