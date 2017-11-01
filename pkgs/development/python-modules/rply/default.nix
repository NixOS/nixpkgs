{ stdenv, fetchurl, buildPythonPackage, appdirs }:

buildPythonPackage rec {
  pname = "rply";
  name = "${pname}-${version}";
  version = "0.7.4";

  src = fetchurl {
    url = "mirror://pypi/r/rply/${name}.tar.gz";
    sha256 = "12rp1d9ba7nvd5rhaxi6xzx1rm67r1k1ylsrkzhpwnphqpb06cvj";
  };

  buildInputs = [ appdirs ];

  meta = with stdenv.lib; {
    description = "A python Lex/Yacc that works with RPython";
    homepage = https://github.com/alex/rply;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
