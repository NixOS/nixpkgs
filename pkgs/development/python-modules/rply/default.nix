{ stdenv, fetchurl, buildPythonPackage, appdirs }:

buildPythonPackage rec {
  pname = "rply";
  name = "${pname}-${version}";
  version = "0.7.5";

  src = fetchurl {
    url = "mirror://pypi/r/rply/${name}.tar.gz";
    sha256 = "0lv428895zxsz43968qx0q9bimwqnfykndz4dpjbq515w2gvzhjh";
  };

  buildInputs = [ appdirs ];

  meta = with stdenv.lib; {
    description = "A python Lex/Yacc that works with RPython";
    homepage = https://github.com/alex/rply;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
