{ stdenv
, buildPythonPackage
, python
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "127yhqc3vjayl7070qvyvcsm08kj1sbq98n7pcmqr782296rvfsm";
  };

  # propagatedBuildInputs = [];

  meta = with stdenv.lib; {
    description = "Pony ORM is easy to use and powerful object-relational mapper";
    longDescription = ''
      Using Pony, developers can create and maintain database-oriented software
      applications faster and with less effort. One of the most interesting
      features of Pony is its ability to write queries to the database using
      generator expressions. Pony then analyzes the abstract syntax tree of a
      generator and translates it to its SQL equivalent.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/ponyorm/pony;
  };
}
