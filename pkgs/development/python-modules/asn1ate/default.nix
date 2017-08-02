{ stdenv, buildPythonPackage, fetchFromGitHub
, pyparsing }:

buildPythonPackage rec {
  pname = "asn1ate";
  date = "20160810";
  name = "${pname}-unstable-${date}";

  src = fetchFromGitHub {
    sha256 = "04pddr1mh2v9qq8fg60czwvjny5qwh4nyxszr3qc4bipiiv2xk9w";
    rev = "c56104e8912400135509b584d84423ee05a5af6b";
    owner = "kimgr";
    repo = pname;
  };

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python library for translating ASN.1 into other forms";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
